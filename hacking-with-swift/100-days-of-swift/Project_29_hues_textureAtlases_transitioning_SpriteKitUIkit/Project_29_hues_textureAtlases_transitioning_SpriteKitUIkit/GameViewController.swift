//
//  GameViewController.swift
//  Project_29_hues_textureAtlases_transitioning_SpriteKitUIkit
//
//  Created by Rafael VSM on 30/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var currentGame: GameScene!
    
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var playerNumber: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var windImageView: UIImageView!
    @IBOutlet var windLabel: UILabel!
    
    var player1Score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(player1Score) X \(player2Score)"
        }
    }
    
    var player2Score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(player1Score) x \(player2Score)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        angleChanged(angleSlider as Any)
        velocityChanged(velocitySlider as Any)
        let image = UIImage(named: "wind")?.withRenderingMode(.alwaysTemplate)
        windImageView.image = image
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // -->
                currentGame = scene as? GameScene
                currentGame.viewcontroller = self
                // Present the scene
                view.presentScene(scene)
                // <--
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }
    
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    
    @IBAction func launch(_ sender: Any) {
        
        angleSlider.isHidden = true
        angleLabel.isHidden = true
        
        velocitySlider.isHidden = true
        velocityLabel.isHidden = true
        
        launchButton.isHidden = true
        
        currentGame.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    func activatePlayer(number: Int) {
        if number == 1 {
            playerNumber.text = "<<< PLAYER 1"
        } else {
            playerNumber.text = "PLAYER 2 >>>"
        }
        
        angleSlider.isHidden = false
        angleLabel.isHidden = false

        velocitySlider.isHidden = false
        velocityLabel.isHidden = false

        launchButton.isHidden = false
    }
    
    func windChange(gravity: Double) {
        let force = gravity * 100
        if gravity < 0.0 {
            windLabel.text = String(format:"East %.2f", CGFloat(abs(force)))
            if gravity < -0.7 {
                // strong
                windImageView.tintColor = .red
            } else if gravity > -0.7 && gravity < -0.3 {
                // medium
                windImageView.tintColor = .yellow
            } else {
                // soft
                windImageView.tintColor = .green
            }
        } else if gravity > 0.0 {
            windLabel.text = String(format:"Weast %.2f", CGFloat(abs(force)))
            if gravity > 0.7 {
                // strong
                windImageView.tintColor = .red
            } else if gravity < 0.7 && gravity > 0.3 {
                // medium
                windImageView.tintColor = .yellow
            } else {
                // soft
                windImageView.tintColor = .green
            }
        } else {
            windLabel.text = String(format:"Sunny %.2f", CGFloat(abs(force)))
            windImageView.tintColor = .blue
        }
    }
}
