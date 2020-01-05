//
//  GameScene.swift
//  ShooterGameChallenge
//
//  Created by Rafael Scalzo on 21/12/19.
//  Copyright © 2019 Rafael Scalzo. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var waterForeground: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var gameTimer: Timer?
    var gameSoundTimer: Timer?
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "stars")
        background.position = CGPoint(x: 512, y: 386)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        let stars = SKEmitterNode(fileNamed: "Spark")!
        stars.position = CGPoint(x: 512, y: 386)
        stars.advanceSimulationTime(10)
        stars.zPosition = -1
        addChild(stars)
        
        scoreLabel = SKLabelNode(fontNamed: "Apple SD Gothic Neo")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 48
        addChild(scoreLabel)
        
        score = 0
        run(SKAction.playSoundFileNamed("gameSound", waitForCompletion: false))
        gameSoundTimer = Timer.scheduledTimer(timeInterval: 32, target: self, selector: #selector(playGameSound), userInfo: nil, repeats: true)
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    }
    
    @objc func playGameSound() {
        run(SKAction.playSoundFileNamed("gameSound", waitForCompletion: false))
    }
    
    @objc func createEnemy() {
        
        let sprite = SKSpriteNode(imageNamed: "newspacecraft")
        sprite.position = CGPoint(x: 512, y: 386)
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.name = "enemy"
        addChild(sprite)
        
        let negativeX = CGFloat.random(in: -1224 ... -1124)
        let positiveX = CGFloat.random(in: 1124...1224)
        let randomX = [positiveX,negativeX].randomElement()!
        
        let negativeY = CGFloat.random(in: -100 ... -50)
        let positiveY = CGFloat.random(in: 868 ... 968)
        let randomY = [negativeY,positiveY].randomElement()!
        
        let action = SKAction.moveBy(x: randomX, y: randomY, duration: 2)
        
        sprite.run(action)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        run(SKAction.playSoundFileNamed("laserShot", waitForCompletion: false))
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            if node.name == "enemy" {
                let explosion = SKEmitterNode(fileNamed: "explosion")!
                run(SKAction.playSoundFileNamed("explosionSound", waitForCompletion: false))
                explosion.position = node.position
                addChild(explosion)
                node.removeFromParent()
                score += 1
                return
            }
        }
        score -= 1
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < 0 || node.position.x > 1024 || node.position.y < 0 || node.position.y > 768 {
                node.removeFromParent()
            }
        }
    }
}
