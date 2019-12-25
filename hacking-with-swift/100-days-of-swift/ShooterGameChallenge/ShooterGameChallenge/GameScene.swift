//
//  GameScene.swift
//  ShooterGameChallenge
//
//  Created by Rafael Scalzo on 21/12/19.
//  Copyright © 2019 Rafael Scalzo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var waterForeground: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
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
        
        let sprite = SKSpriteNode(imageNamed: "spacecraft")
        sprite.position = CGPoint(x: 300, y: 300)
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        addChild(sprite)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
