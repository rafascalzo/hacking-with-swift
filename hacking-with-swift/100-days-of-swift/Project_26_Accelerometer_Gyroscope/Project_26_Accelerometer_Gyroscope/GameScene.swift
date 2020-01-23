//
//  GameScene.swift
//  Project_26_Accelerometer_Gyroscope
//
//  Created by Rafael VSM on 22/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

// Note that your bitmasks should start at 1 then double each time.
enum CollisionTypes: UInt32 {
    
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    
    func value() -> UInt32 {
        return self.rawValue
    }
}

// Each square in the game world occupies a 64x64 space, so we can find its position by multiplying its row and column by 64. But: remember that SpriteKit calculates its positions from the center of objects, so we need to add 32 to the X and Y coordinates in order to make everything lines up on our screen.

// SpriteKit uses an inverted Y axis to UIKit, which means for SpriteKit Y:0 is the bottom of the screen whereas for UIKit Y:0 is the top. When it comes to loading level rows, this means we need to read them in reverse so that the last row is created at the bottom of the screen and so on upwards.

class GameScene: SKScene {
    
    var player: SKSpriteNode!
    var motionManager: CMMotionManager!
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 15)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        
        loadLevel()
        createPlayer()
        
        physicsWorld.gravity = .zero
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
    }
    
    // The categoryBitMask property is a number defining the type of object this is for considering collisions.
    // The collisionBitMask property is a number defining what categories of object this node should collide with,
    // The contactTestBitMask property is a number defining which collisions we want to be notified about.
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.value()
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.value() | CollisionTypes.vortex.value() | CollisionTypes.finish.value()
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.value()
        addChild(player)
    }
    
    func loadLevel() {
        guard let levelURL = Bundle.main.url(forResource: "level1", withExtension: "txt") else {
            fatalError("Could not find level1.txt on the app bundle.")
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not load level1.txt from the app bundle.")
        }
        
        let lines = levelString.components(separatedBy: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
                if letter == "x" {
                    // load wall
                    let node = SKSpriteNode(imageNamed: "block")
                    node.position = position
                    
                    node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                    node.physicsBody?.categoryBitMask = CollisionTypes.wall.value()
                    node.physicsBody?.isDynamic = false
                    addChild(node)
                } else if letter == "v" {
                    let node = SKSpriteNode(imageNamed: "vortex")
                    node.name = "vortex"
                    node.position = position
                    node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
                    node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                    node.physicsBody?.isDynamic = false
                    
                    node.physicsBody?.categoryBitMask = CollisionTypes.vortex.value()
                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.value()
                    node.physicsBody?.collisionBitMask = 0
                    addChild(node)
                    // load vortex
                } else if letter == "s"{
                    // load star
                    let node = SKSpriteNode(imageNamed: "star")
                    node.name = "star"
                    node.position = position
                    node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                    node.physicsBody?.isDynamic = false
                    
                    node.physicsBody?.categoryBitMask = CollisionTypes.star.value()
                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.value()
                    node.physicsBody?.collisionBitMask = 0
                    addChild(node)
                } else if letter == "f" {
                    // load finish
                    let node = SKSpriteNode(imageNamed: "finish")
                    node.name = "finish"
                    node.position = position
                    node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                    node.physicsBody?.isDynamic = false
                    
                    node.physicsBody?.categoryBitMask = CollisionTypes.finish.value()
                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.value()
                    node.physicsBody?.collisionBitMask = 0
                    addChild(node)
                    
                } else if letter == " " {
                    // this is an empty space, do nothing
                } else {
                    fatalError("Unknown level letter: \(letter)")
                }
            }
        }
    }
    
    // we're going to put together a hack that lets you simulate the experience of moving the ball using touch. What we're going to do is catch touchesBegan(), touchesMoved(), and touchesEnded(), and use them to set or unset a new property called lastTouchPosition. Then in the update() method we'll subtract that touch position from the player's position, and use it set the world's gravity.
    
    var lastTouchPosition: CGPoint?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        lastTouchPosition = touch.location(in: self)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        lastTouchPosition = touch.location(in: self)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    // Easy, I know, but it gets (only a little!) trickier in the update() method. This needs to unwrap our optional property, calculate the difference between the current touch and the player's position, then use that to change the gravity value of the physics world. Here it is:
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        #if targetEnvironment(simulator)
        if let currentTouch = lastTouchPosition {
            let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    // Now for the new bit: working with the accelerometer. This is easy to do, which is remarkable when you think how much is happening behind the scenes.

    // All motion detection is done with an Apple framework called Core Motion, and most of the work is done by a class called CMMotionManager. Using it here won't require any special user permissions, so all we need to do is create an instance of the class and ask it to start collecting information. We can then read from that information whenever and wherever we need to, and in this project the best place is update().
    
    // The last thing to do is to poll the motion manager inside our update() method, checking to see what the current tilt data is. But there's a complication: we already have a hack in there that lets us test in the simulator, so we want one set of code for the simulator and one set of code for devices.

    // Swift solves this problem by adding special compiler instructions. If the instruction evaluates to true it will compile one set of code, otherwise it will compile the other. This is particularly helpful once you realize that any code wrapped in compiler instructions that evaluate to false never get seen – it's like they never existed. So, this is a great way to include debug information or activity in the simulator that never sees the light on devices.

    // The compiler directives we care about are: #if targetEnvironment(simulator), #else and #endif. As you can see, this is mostly the same as a standard Swift if/else block, although here you don't need braces because everything until the #else or #endif will execute.
    
    // The first line safely unwraps the optional accelerometer data, because there might not be any available. The second line changes the gravity of our game world so that it reflects the accelerometer data. You're welcome to adjust the speed multipliers as you please; I found a value of 50 worked well.

    // Note that I passed accelerometer Y to CGVector's X and accelerometer X to CGVector's Y. This is not a typo! Remember, your device is rotated to landscape right now, which means you also need to flip your coordinates around.
    
}
