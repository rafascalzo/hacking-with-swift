//
//  GameScene.swift
//  Project20_touches_and_shakes
//
//  Created by Rafael Scalzo on 30/12/19.
//  Copyright © 2019 Rafael Scalzo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    var scoreLabel: SKLabelNode!
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score \(score)"
        }
    }
    
    var playTime = 0 {
        didSet {
            if playTime == 7 {
                gameTimer?.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                    self.scoreLabel.text = "Game Over! Score: \(self.score)"
                }
                
            }
        }
    }

    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 512, y: 16)
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.zPosition = -1
        addChild(scoreLabel)
        
        score = 0
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    @objc func launchFireworks() {
       playTime += 1
        let movementAmount: CGFloat = 1800
        
        switch Int.random(in: 0...3) {
        case 0:
            // fire five, straight up
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
            
        case 1:
            // fire five, in a fan
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
        case 2:
            // fire five, from the left to the right
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
        case 3:
            // fire five, from the right to the left
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
        default:
            break
        }
    }
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        //Create an SKNode that will act as the firework container, and place it at the position that was specified.
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        //Create a rocket sprite node, give it the name "firework" so we know that it's the important thing, adjust its colorBlendFactor property so that we can color it, then add it to the container node.
        let firework = SKSpriteNode(imageNamed: "rocket")
        //set to 1 (use the new color exclusively)
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        //Give the firework sprite node one of three random colors: cyan, green or red. I've chosen cyan because pure blue isn't particularly visible on a starry sky background picture.
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        case 2:
            firework.color = .red
        default:
            break
        }
        //Create a UIBezierPath that will represent the movement of the firework.
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        //Tell the container node to follow that path, turning itself as needed.
        //If you specify asOffset as true, it means any coordinates in your path are adjusted to take into account the node's position.
        //The third parameter to follow() is orientToPath and makes a complicated task into an easy one. When it's set to true, the node will automatically rotate itself as it moves on the path so that it's always facing down the path. Perfect for fireworks, and indeed most things! Finally, you can specify a speed to adjust how fast it moves along the path.
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        //Create particles behind the rocket to make it look like the fireworks are lit.
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        //Add the firework to our fireworks array and also to the scene.
        fireworks.append(node)
        addChild(node)
        
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                // this uses a position high above so that rockets can explode off
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    func explode(firework: SKNode) {
        run(SKAction.playSoundFileNamed("firework", waitForCompletion: false))
        
        if let emmiter = SKEmitterNode(fileNamed: "explode") {
            emmiter.position = firework.position
            addChild(emmiter)
            run(SKAction.wait(forDuration: TimeInterval(exactly: emmiter.particleLifetime) ?? 0.0)) {
                emmiter.removeFromParent()
            }
        }
        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numExploded = 0
        
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { return }
            if firework.name == "selected" {
                // esxplode this firework
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        
        switch numExploded {
        case 0:
            // nothing - rubbish!
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        case 5:
            score += 4000
        default:
            break
        }
    }
}
