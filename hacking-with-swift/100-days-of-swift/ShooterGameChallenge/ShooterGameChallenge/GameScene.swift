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
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "curtains")
        background.position = CGPoint(x: 512, y: 386)
        background.zPosition = -1
        //background.blendMode = .replace
        addChild(background)
        
        let water = SKSpriteNode(imageNamed: "water-bg")
        water.position = CGPoint(x: 512, y: 198)
        water.zPosition = -1
        water.blendMode = .replace
        addChild(water)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
