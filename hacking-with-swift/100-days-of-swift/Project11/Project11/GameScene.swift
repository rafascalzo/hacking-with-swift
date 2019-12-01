//
//  GameScene.swift
//  Project11
//
//  Created by rafaeldelegate on 11/3/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score \(score)"
        }
    }
    var ballCounter:Int = 0 {
        didSet {
            ballsLeftLabel.text = "Balls left \(maximumBalls - ballCounter)"
        }
    }
    
    var ballsLeftLabel: SKLabelNode!
    
    var maximumBalls:Int = 5 {
        didSet {
            ballsLeftLabel.text = "Balls left \(maximumBalls - ballCounter)"
        }
    }
    
    let ballNames = ["ballRed","ballBlue", "ballCyan", "ballGreen","ballGrey","ballPurple","ballYellow"]
    
    var editLabel: SKLabelNode!
    
    var editingMode:Bool = false {
        
        didSet{
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
       let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkdusker")
        scoreLabel.text = "Score 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkdusker")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        ballsLeftLabel = SKLabelNode(fontNamed: "Charkdusker")
        ballsLeftLabel.text = "Balls left 5"
        ballsLeftLabel.position = CGPoint(x: 512, y: 700)
        addChild(ballsLeftLabel)
        
        makeBouncerAt(position: CGPoint(x: 0, y: 0))
        makeBouncerAt(position: CGPoint(x: 256, y: 0))
        makeBouncerAt(position: CGPoint(x: 512, y: 0))
        makeBouncerAt(position: CGPoint(x: 768, y: 0))
        makeBouncerAt(position: CGPoint(x: 1024, y: 0))
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location  = touch.location(in: self)
        
        let object = nodes(at: location)
        
        if object.contains(editLabel) {
            editingMode.toggle()
        } else {
            if editingMode {
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                box.name = "obstacle"
                addChild(box)
            } else {
                if ballCounter >= maximumBalls {
                    score = 0
                    for node in self.children {
                        if node.name == "obstacle" {
                            node.removeFromParent()
                        }
                    }
                    ballCounter = 0
                    maximumBalls = 5
                } else {
                    let ball = SKSpriteNode(imageNamed: ballNames.randomElement()!)
                    ball.name = "ball"
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody?.restitution = 0.9
                    ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                    ball.position = CGPoint(x: location.x, y: 768)
                    addChild(ball)
                    ballCounter += 1
                }
                
            }
            
        }
    }
    
    func makeBouncerAt(position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    func makeSlot(at position: CGPoint, isGood: Bool) {
        
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotBase.name = "good"
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotBase.name = "bad"
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
        }
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
            maximumBalls += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        }
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
}
/*
 SKEmitterNode
 
Particle Texture: what image to use for your particles.
Particles Birthrate: how fast to create new particles.
Particles Maximum: the maximum number of particles this emitter should create before finishing.
Lifetime Start: the basic value for how many seconds each particle should live for.
Lifetime Range: how much, plus or minus, to vary lifetime.
Position Range X/Y: how much to vary the creation position of particles from the emitter node's position.
Angle Start: which angle you want to fire particles, in degrees, where 0 is to the right and 90 is straight up.
Angle Range: how many degrees to randomly vary particle angle.
Speed Start: how fast each particle should move in its direction.
Speed Range: how much to randomly vary particle speed.
Acceleration X/Y: how much to affect particle speed over time. This can be used to simulate gravity or wind.
Alpha Start: how transparent particles are when created.
Alpha Range: how much to randomly vary particle transparency.
Alpha Speed: how much to change particle transparency over time. A negative value means "fade out."
Scale Start / Range / Speed: how big particles should be when created, how much to vary it, and how much it should change over time. A negative value means "shrink slowly."
Rotation Start / Range / Speed: what Z rotation particles should have, how much to vary it, and how much they should spin over time.
Color Blend Factor / Range / Speed: how much to color each particle, how much to vary it, and how much it should change over time.
*/
