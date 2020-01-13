//
//  GameScene.swift
//  Project_23_SKShapeNode_AVAudioPlayer_UIBezierPath
//
//  Created by Rafael VSM on 11/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

enum SequenceType: CaseIterable {
    case oneNoBomb, one, twoWithOneBomb, two, three, four, chain, fastChain
}

enum ForceBomb {
    case never, aways, random
}

class GameScene: SKScene {
    
    var gameScore: SKLabelNode!
    
    var score = 0 {
        didSet {
            gameScore.text = "Score \(score)"
        }
    }
    
    var livesImages = [SKSpriteNode]()
    var lives = 3
    
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    
    var activeSlicesPoints = [CGPoint]()
    
    var isSwooshSoundActive = false
    
    var activeEnemies = [SKSpriteNode]()
    
    var bombSoundEffect: AVAudioPlayer?
    
    // the amount of time to wait between the last enemy being destroyed and a new one being created.
    var poputTime = 0.9
    var sequence = [SequenceType]()
    var sequencePosition = 0
    
    // how long to wait before creating a new enemy when the sequence type is .chain or .fastChain
    var chainDelay = 3.0
    
    //  know when all the enemies are destroyed and we're ready to create more.
    var nextSequenceQueue = true
    
    var isGameEnded = false
    
    var gameOver: SKSpriteNode!
    var playAgain: SKLabelNode!
    
    func createEnemy(forceBomb: ForceBomb = .random) {
        let enemy: SKSpriteNode
        
        var enemyType = Int.random(in: 0...6)
        
        if forceBomb == .never {
            enemyType = 1
        } else if forceBomb == .aways {
            enemyType = 0
        }
        
        if enemyType == 0 {
            // bomb code goes here
            // Create a new SKSpriteNode that will hold the fuse and the bomb image as children, setting its Z position to be 1.
            enemy = SKSpriteNode()
            enemy.zPosition = 1
            enemy.name = "bombContainer"
            // Create the bomb image, name it "bomb", and add it to the container.
            
            let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
            bombImage.name = "bomb"
            enemy.addChild(bombImage)
            
            // If the bomb fuse sound effect is playing, stop it and destroy it.
            if bombSoundEffect != nil {
                bombSoundEffect?.stop()
                bombSoundEffect = nil
            }
            
            // Create a new bomb fuse sound effect, then play it.
            if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: "caf") {
                if let sound = try? AVAudioPlayer(contentsOf: path) {
                    bombSoundEffect = sound
                    sound.play()
                }
            }
            
            // Create a particle emitter node, position it so that it's at the end of the bomb image's fuse, and add it to the container.
            if let emitter = SKEmitterNode(fileNamed: "sliceFuse") {
                emitter.position = CGPoint(x: 76, y: 64)
                enemy.addChild(emitter)
            }
            
        } else if enemyType == 6 {
            enemy = SKSpriteNode(imageNamed: "monster")
            run(SKAction.playSoundFileNamed("monsters-scream.wav", waitForCompletion: false))
            enemy.name = "monster"
        } else {
            enemy = SKSpriteNode(imageNamed: "penguin")
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
            enemy.name = "enemy"
        }
        
        // position code goes here
        let randomPosition = CGPoint(x: Int.random(in: 64...960), y: -128)
        enemy.position = randomPosition
        
        // Create a random angular velocity, which is how fast something should spin.
        let randomAngularVelocity = CGFloat.random(in: -3...3)
        let randomXVelocity: Int
        
        // Create a random X velocity (how far to move horizontally) that takes into account the enemy's position.
        if randomPosition.x < 256 {
            randomXVelocity = Int.random(in: 8...15)
        } else if randomPosition.x < 512 {
            randomXVelocity = Int.random(in: 3...5)
        } else if randomPosition.x < 768 {
            randomXVelocity = -Int.random(in: 3...5)
        } else {
            randomXVelocity = -Int.random(in: 8...15)
        }
        
        // Create a random Y velocity just to make things fly at different speeds.
        
        let randomYVelocity = Int.random(in: 24...32)
        
        // Give all enemies a circular physics body where the collisionBitMask is set to 0 so they don't collide.
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
        enemy.physicsBody?.angularVelocity = randomAngularVelocity
        enemy.physicsBody?.collisionBitMask = 0
        
        addChild(enemy)
        activeEnemies.append(enemy)
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        //The default gravity of our physics world is -0.98, which is roughly equivalent to Earth's gravity
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
        
        createScore()
        createLives()
        createSlices()
        
        gameOver = SKSpriteNode(imageNamed: "game_over")
        gameOver.position = CGPoint(x: 512, y: 384)
        
        
        playAgain = SKLabelNode(fontNamed: "Chalkduster")
        playAgain.text = "Play again"
        playAgain.fontSize = 56
        playAgain.position = CGPoint(x: 512, y: 110)
        
        sequence = [.oneNoBomb, .oneNoBomb, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]
        
        for _ in 0 ... 100 {
            if let nextSequence = SequenceType.allCases.randomElement() {
                sequence.append(nextSequence)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.tossEnemies()
        }
    }
    
    func createScore() {
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        gameScore.position = CGPoint(x: 8, y: 8)
        score = 0
    }
    
    func createLives() {
        
        for i in 0 ..< 3 {
            let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
            spriteNode.position = CGPoint(x: CGFloat(834 + (i * 70)), y: 720)
            addChild(spriteNode)
            
            livesImages.append(spriteNode)
        }
    }
    
    func createSlices() {
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBG.lineWidth = 9
        addChild(activeSliceBG)
        
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 3
        activeSliceFG.strokeColor = .white
        activeSliceFG.lineWidth = 5
        addChild(activeSliceFG)
    }
    
    func tossEnemies() {
        
        if isGameEnded {
            return
        }
        
        poputTime *= 0.991
        chainDelay *= 0.99
        physicsWorld.speed *= 1.02
        
        let sequenceType = sequence[sequencePosition]
        
        switch sequenceType {
        case .oneNoBomb: createEnemy(forceBomb: .never)
        case .one: createEnemy()
        case .twoWithOneBomb: createEnemy(forceBomb: .never); createEnemy(forceBomb: .aways)
        case .two: createEnemy(); createEnemy()
        case .three: createEnemy(); createEnemy(); createEnemy()
        case .four: createEnemy(); createEnemy(); createEnemy(); createEnemy()
        case .chain:
            createEnemy()
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0)) { [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 2)) { [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 3)) { [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 4)) { [weak self] in
                self?.createEnemy()
            }
        case .fastChain:
            createEnemy()
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) { [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 2)) { [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 3)) { [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 4)) { [weak self] in
                self?.createEnemy()
            }
        }
        
        sequencePosition += 1
        nextSequenceQueue = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
       
        let location = touch.location(in: self)
        
        let object = nodes(at: location)
        
        if object.contains(playAgain) {
            score = 0
            lives = 3
            for i in 0 ..< 3 {
                livesImages[i].texture = SKTexture(imageNamed: "sliceLife")
            }
            physicsWorld.speed = 0.85
            gameOver.removeFromParent()
            playAgain.removeFromParent()
            isGameEnded = false
            sequencePosition = 0
            
            for (index, node) in activeEnemies.enumerated().reversed() {
                if node.name == "enemy" || node.name == "monster" {
                    node.removeFromParent()
                    node.name = ""
                    
                    activeEnemies.remove(at: index)
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.tossEnemies()
            }
        }
        
        activeSlicesPoints.removeAll(keepingCapacity: true)
        
        activeSlicesPoints.append(location)
        
        redrawActiveSlice()
        
        activeSliceFG.removeAllActions()
        activeSliceBG.removeAllActions()
        
        activeSliceFG.alpha = 1
        activeSliceBG.alpha = 1
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameEnded {
            return
        }
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        activeSlicesPoints.append(location)
        redrawActiveSlice()
        if !isSwooshSoundActive {
            playSwooshSound()
        }
        
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint {
            if node.name == "enemy" || node.name == "monster" {
                if let emmiter = SKEmitterNode(fileNamed: "sliceHitEnemy") {
                    emmiter.position = node.position
                    addChild(emmiter)
                }
                
                // Clear its node name so that it can't be swiped repeatedly.
                node.name = ""
                
                // Disable the isDynamic of its physics body so that it doesn't carry on falling.
                node.physicsBody?.isDynamic = false
                
                // Make the penguin scale out and fade out at the same time.
                let scaleOut = SKAction.scale(by: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeIn(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut])
                
                // After making the penguin scale out and fade out, we should remove it from the scene.
                let sequence = SKAction.sequence([group, .removeFromParent()])
                node.run(sequence)
                
                if node.name == "monster" {
                    score += 10
                    lives = 3
                    for i in 0 ..< 3 {
                        livesImages[i].texture = SKTexture(imageNamed: "sliceLife")
                    }
                } else {
                    score += 1
                }
                
                
                // Remove the enemy from our activeEnemies array.
                if let index = activeEnemies.firstIndex(of: node) {
                    activeEnemies.remove(at: index)
                }
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            } else if node.name == "bomb" {
                guard let bombContainer = node.parent as? SKSpriteNode else { continue }
                
                if let emitter = SKEmitterNode(fileNamed: "sliceHitBomb") {
                    emitter.position = bombContainer.position
                    addChild(emitter)
                }
                
                node.name = ""
                node.physicsBody?.isDynamic = false
                
                let scaleOut = SKAction.scale(by: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeIn(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut])
                let sequence = SKAction.sequence([group, .removeFromParent()])
                bombContainer.run(sequence)
                
                if let index = activeEnemies.firstIndex(of: bombContainer) {
                    activeEnemies.remove(at: index)
                }
                
                run(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false))
                endGame(triggeredByBomb: true)
            }
        }
    }
    
    func endGame(triggeredByBomb: Bool) {
        if isGameEnded {
           return
        }
        
        isGameEnded = true
        physicsWorld.speed = 0
        //isUserInteractionEnabled = false
        
        bombSoundEffect?.stop()
        bombSoundEffect = nil
        
        if triggeredByBomb {
            livesImages[0].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[1].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[2].texture = SKTexture(imageNamed: "sliceLifeGone")
        }
        
        
        gameOver.zPosition = 5
        addChild(gameOver)
        
        playAgain.zPosition = 6
        addChild(playAgain)
        
        run(SKAction.playSoundFileNamed("game-over-arcade.wav", waitForCompletion: false))
    }
    
    func playSwooshSound() {
        isSwooshSoundActive = true
        
        let randomNumber = Int.random(in: 1 ... 3)
        let soundName = "swoosh\(randomNumber).caf"
        
        let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        
        run(swooshSound) { [weak self] in
            self?.isSwooshSoundActive = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    func redrawActiveSlice() {
        
        // If we have fewer than two points in our array, we don't have enough data to draw a line so it needs to clear the shapes and exit the method.
        
        if activeSlicesPoints.count < 2 {
            activeSliceFG.path = nil
            activeSliceBG.path = nil
            return
        }
        
        if activeSlicesPoints.count > 12 {
            activeSlicesPoints.removeFirst(activeSlicesPoints.count - 12)
        }
        
        // It needs to start its line at the position of the first swipe point, then go through each of the others drawing lines to each point.
        
        let path = UIBezierPath()
        path.move(to: activeSlicesPoints[0])
        
        for i in 1 ..< activeSlicesPoints.count {
            path.addLine(to: activeSlicesPoints[i])
        }
        
        // update the slice shape paths so they get drawn using their designs – i.e., line width and color.
        
        activeSliceBG.path = path.cgPath
        activeSliceFG.path = path.cgPath
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        var bombCount = 0
        
        for node in activeEnemies {
            if node.name == "bombContainer" {
                bombCount += 1
                break
            }
        }
        
        if bombCount == 0 {
            // no bombs, stop the fuse sound!
            bombSoundEffect?.stop()
            bombSoundEffect = nil
        }
        
        if activeEnemies.count > 0 {
            for (index, node) in activeEnemies.enumerated().reversed() {
                if node.position.y < -140 {
                    node.removeAllActions()
                    
                    if node.name == "enemy" {
                        node.name = ""
                        subtractLife()
                        
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    } else if node.name == "bombContainer" {
                        node.name = ""
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    }
                }
                
            }
        } else {
            if !nextSequenceQueue {
                DispatchQueue.main.asyncAfter(deadline: .now() + poputTime) { [weak self] in
                    self?.tossEnemies()
                }
                nextSequenceQueue = true
            }
        }
    }
    
    func subtractLife() {
        lives -= 1
        
        run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))
        
        var life: SKSpriteNode
        
        if lives == 2 {
            life = livesImages[0]
        } else if lives == 1 {
            life = livesImages[1]
        } else {
            life = livesImages[2]
            endGame(triggeredByBomb: false)
        }
        
        life.texture = SKTexture(imageNamed: "sliceLifeGone")
        
        life.xScale = 1.3
        life.yScale = 1.3
        life.run(SKAction.scale(to: 1, duration: 0.1))
    }
}
