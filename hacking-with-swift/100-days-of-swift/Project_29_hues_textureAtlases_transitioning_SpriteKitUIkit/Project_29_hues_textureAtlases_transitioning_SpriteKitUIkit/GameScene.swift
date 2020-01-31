//
//  GameScene.swift
//  Project_29_hues_textureAtlases_transitioning_SpriteKitUIkit
//
//  Created by Rafael VSM on 30/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.


enum CollisionTypes: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    weak var viewcontroller: GameViewController!
    
    var buildings = [BuildingNode]()
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.067, alpha: 1)
        createBuildings()
    }
    
    func createBuildings() {
        var currentX:CGFloat = -15
        
        while currentX < 1024 {
            let size = CGSize(width: Int.random(in: 2...4) * 40, height: Int.random(in: 300...600))
            currentX += size.width + 2
            
            let building = BuildingNode(color: UIColor.red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)
            
            buildings.append(building)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func launch(angle: Int, velocity: Int) {
        
    }
}
