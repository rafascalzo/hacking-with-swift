//
//  GameScene.swift
//  Project_29_hues_textureAtlases_transitioning_SpriteKitUIkit
//
//  Created by Rafael VSM on 30/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.

/*
SpriteKit uses a number of optimizations to help its physics simulation work at high speed. These optimizations don't work well with small, fast-moving objects, and our banana is just such a thing. To be sure everything works as intended, we're going to enable the usesPreciseCollisionDetection property for the banana's physics body. This works slower, but it's fine for occasional use.
 
 I said we needed to make the banana move in "the correct direction" without really explaining how we get to that. This isn't a trigonometry book, so here's the answer as briefly as possible: if we calculate the cosine of our angle in radians it will tell us how much horizontal momentum to apply, and if we calculate the sine of our angle in radians it will tell us how much vertical momentum to apply.
 
 Once that momentum is calculated, we multiply it by the velocity we calculated (or negative velocity in the case of being player 2, because we want to throw to the left), and turn it into a CGVector. Remember, a vector is like an arrow where its base is at 0,0 (our current position) and tip at the point we specify, so this effectively points an arrow in the direction the banana should move.

 To make the banana actually move, we use the applyImpulse() method of its physics body, which accepts a CGVector as its only parameter and gives it a physical push in that direction.
 
 To transition from one scene to another, you first create the scene, then create a transition using the list available from SKTransition, then finally use the presentScene() method of our scene's view, passing in the new scene and the transition you created. For example, this will cross-fade in a new scene over 2 seconds:

 let newGame = GameScene(size: self.size)
 let transition = SKTransition.crossFade(withDuration: 2)
 self.view?.presentScene(newGame, transition: transition)
 */

enum CollisionTypes: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}

import SpriteKit
import GameplayKit

class GameScene: SKScene , SKPhysicsContactDelegate {
    
    weak var viewcontroller: GameViewController!
    
    var buildings = [BuildingNode]()
    
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    
    var currentPlayer = 1
    
    override func didMove(to view: SKView) {
        
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.067, alpha: 1)
        createBuildings()
        createPlayers()
        
        physicsWorld.contactDelegate = self
        let randomX = Double.random(in: -1 ... 1)
        physicsWorld.gravity = CGVector(dx: randomX, dy: -1)
        viewcontroller.windChange(gravity: randomX)
        
        if viewcontroller.player1Score == 0 && viewcontroller.player2Score == 0 {
            print("game scene")
            viewcontroller.player1Score = 0
            viewcontroller.player2Score = 0
        } else if viewcontroller.player2Score == 3 || viewcontroller.player1Score == 3 {
            viewcontroller.player1Score = 0
            viewcontroller.player2Score = 0
        }
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
    
    func degreesToRadians(degrees: Int) -> Double {
        return Double(degrees) * Double.pi / 180
    }
    
    func createPlayers() {
        player1 = SKSpriteNode(imageNamed: "player")
        player1.name = "player1"
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player1.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.isDynamic = false
        
        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + ((player1Building.size.height + player1.size.height) / 2))
        addChild(player1)
        
        player2 = SKSpriteNode(imageNamed: "player")
        player2.name = "player2"
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
        player2.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player2.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.isDynamic = false
        
        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y  + ((player2Building.size.height + player2.size.height) / 2))
        addChild(player2)
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard banana != nil else { return }
        
        if abs(banana.position.y) > 1000 {
            banana.removeFromParent()
            banana = nil
            changePlayer()
        }
    }
    
    func launch(angle: Int, velocity: Int) {
        // Figure out how hard to throw the banana. We accept a velocity parameter, but I'll be dividing that by 10. You can adjust this based on your own play testing.
        let speed = Double(velocity) / 10.0
        
        // Convert the input angle to radians. Most people don't think in radians, so the input will come in as degrees that we will convert to radians.
        let radians = degreesToRadians(degrees: angle)
        
        // If somehow there's a banana already, we'll remove it then create a new one using circle physics.
         if banana != nil {
               banana.removeFromParent()
               banana = nil
           }

           banana = SKSpriteNode(imageNamed: "banana")
           banana.name = "banana"
           banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
           banana.physicsBody?.categoryBitMask = CollisionTypes.banana.rawValue
           banana.physicsBody?.collisionBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
           banana.physicsBody?.contactTestBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
           banana.physicsBody?.usesPreciseCollisionDetection = true
           addChild(banana)
        
        // If player 1 was throwing the banana, we position it up and to the left of the player and give it some spin.
        if currentPlayer == 1 {
            banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
            banana.physicsBody?.angularVelocity = -20
            
            // Animate player 1 throwing their arm up then putting it down again.
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player1.run(sequence)
            
            // Make the banana move in the correct direction.
            
            let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        } else {
            banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
            banana.physicsBody?.angularVelocity = 20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            
            player2.run(sequence)
            
            let impuse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impuse)
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        guard let firstNode = firstBody.node else { return }
        guard let secondNode = secondBody.node else { return }
        
        if firstNode.name == "banana" && secondNode.name == "building" {
            bananaHit(building: secondNode, atPoint: contact.contactPoint)
        } else if firstNode.name == "banana" && secondNode.name == "player1" {
            viewcontroller.player2Score += 1
            destroy(player1)
        } else if firstNode.name == "banana" && secondNode.name == "player2" {
            viewcontroller.player1Score += 1
            destroy(player2)
        }
    }
    
    // The only new thing in there is the call to convert(), which asks the game scene to convert the collision contact point into the coordinates relative to the building node. That is, if the building node was at X:200 and the collision was at X:250, this would return X:50, because it was 50 points into the building node.
    func bananaHit(building: SKNode, atPoint contactPoint: CGPoint) {
        guard let building = building as? BuildingNode else { return }
        let buildingLocation = convert(contactPoint, to: building)
        building.hit(at: buildingLocation)
        
        if let explosion = SKEmitterNode(fileNamed: "hitBuilding") {
            explosion.position = contactPoint
            addChild(explosion)
        }
        
        banana.name = ""
        banana.removeFromParent()
        banana = nil
        
        changePlayer()
    }
    
    func destroy(_ player: SKSpriteNode) {
        if let explosion = SKEmitterNode(fileNamed: "hitPlayer") {
            explosion.position = player.position
            addChild(explosion)
        }
        
        player.removeFromParent()
        banana.removeFromParent()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let newGame = GameScene(size: self.size)
            newGame.viewcontroller = self.viewcontroller
            self.viewcontroller.currentGame = newGame
            
            self.changePlayer()
            newGame.currentPlayer = self.currentPlayer
            
            let transition = SKTransition.doorway(withDuration: 1.5)
            self.view?.presentScene(newGame, transition: transition)
        }
    }
    
    func changePlayer() {
        
        if currentPlayer == 1 {
            currentPlayer = 2
        } else {
            currentPlayer = 1
        }
        viewcontroller.activatePlayer(number: currentPlayer)
    }
}
