//
//  MainViewController.swift
//  Project2
//
//  Created by rafaelviewcontroller on 10/3/19.
//  Copyright © 2019 rafaelviewcontroller. All rights reserved.
//

import UIKit

class Player: NSObject, NSCoding {

    var score: Int
    var highestScore: Int
    
    init(score: Int, highestScore: Int) {
        self.score = score
        self.highestScore = highestScore
    }
    required init?(coder: NSCoder) {
        score = coder.decodeObject(forKey: "score") as? Int ?? 0
        highestScore = coder.decodeObject(forKey: "highestScore") as? Int ?? 0
    }
    func encode(with coder: NSCoder) {
        coder.encode(score, forKey: "score")
        coder.encode(highestScore, forKey: "highestScore")
    }
}

class MainViewController: UIViewController {
    
    @IBOutlet var firstButton: UIButton!
    @IBOutlet var secondButton: UIButton!
    @IBOutlet var thirdButton: UIButton!
    
    var countries = [String]()
    var player: Player!
    var correctAnswer = 0
    var questionNumber = 0
    var alertMessage: String = ""
    
    var labelScore: UILabel = {
        let lb = UILabel()
        lb.text = "Score 0"
        lb.textAlignment = .center
        return lb
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "player") as? Data {
            
            do {
                let decodedPlayer = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? Player
                self.player = decodedPlayer
            } catch let error {
                print("Failed to get savedPlayer", error.localizedDescription)
            }
//            if let decodedPlayer = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? Player {
//                self.player = decodedPlayer
//            }
        } else {
            player = Player(score: 0, highestScore: 0)
        }
//        if let navigationBar = navigationController?.navigationBar {
//            
//            // labelScore.frame = CGRect(x: navigationBar.frame.maxX - 80, y: 0, width: 120, height: navigationBar.frame.height)
//            
//            navigationBar.addSubview(labelScore)
//            labelScore.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([labelScore.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
//                                         labelScore.widthAnchor.constraint(equalToConstant: 120),
//                                         labelScore.heightAnchor.constraint(equalTo: navigationBar.heightAnchor),
//                                         labelScore.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor)])
//        }
        
        let btn = UIBarButtonItem(title: "SCORE", style: .plain, target: self, action: #selector(handleTapped))
        
        navigationItem.rightBarButtonItem = btn
        countries+=["estonia","france","germany","ireland","italy","monaco","nigeria","poland","russia","spain","uk","us"]
        firstButton.layer.borderWidth = 1
        secondButton.layer.borderWidth = 1
        thirdButton.layer.borderWidth = 1
        
        firstButton.layer.borderColor = UIColor.lightGray.cgColor
        secondButton.layer.borderColor = UIColor(red: 1, green: 0.6, blue: 0.2, alpha: 1).cgColor
        thirdButton.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        // Do any additional setup after loading the view.
    }
    @objc func handleTapped(_ action: UIBarButtonItem) {
        let alert = UIAlertController(title: "Score", message: "Your score is \(player.score)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    func askQuestion(action: UIAlertAction! = nil) {
        
        countries.shuffle()
        correctAnswer = Int.random(in: 1...2)
        
        title = countries[correctAnswer].uppercased()
        
        firstButton.setImage(UIImage(named: countries[0]), for: .normal)
        secondButton.setImage(UIImage(named: countries[1]), for: .normal)
        thirdButton.setImage(UIImage(named: countries[2]), for: .normal)
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }) { finished in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                sender.transform = .identity
            }) { finished in
                 var title: String
                       
                if sender.tag == self.correctAnswer {
                           title = "Correct"
                    self.player.score += 1;
                    self.labelScore.text = "Score \(self.player.score )"
                    self.alertMessage = "Correct! Thats the flag of \(self.countries[sender.tag] )"
                       } else {
                           title = "Wrong"
                    self.alertMessage = "Wrong! Thats the flag of \(self.countries[sender.tag] )"
                       }
                self.questionNumber += 1
                       
                var alert = UIAlertController(title: title, message: self.alertMessage, preferredStyle: .alert)
                       
                if self.questionNumber == 10 {
                    alert = UIAlertController(title: title, message: "Your final score is \(self.player.score )", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Reset Game", style: .default, handler: self.showGrats))
                           
                       } else {
                           
                    alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: self.askQuestion))
                       }
                self.present(alert, animated: true)
            }
        }
       
    }
    
    func showGrats(_ action: UIAlertAction! = nil) {
        print(player.score, player.highestScore)
        if player.score > player.highestScore {
            player.highestScore = player.score
            save()
            
            let ac = UIAlertController(title: "Top first!", message: "Congrats! you hit the highest score \(player.highestScore)", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Yuhul", style: .default, handler: askQuestion)
            ac.addAction(ok)
            present(ac, animated: true)
        } else {
            askQuestion()
        }
        labelScore.text = "Score 0"
        player.score = 0
        questionNumber = 0
    }
    
    func save() {
        let defaults = UserDefaults.standard
        if let encodedPlayer = try? NSKeyedArchiver.archivedData(withRootObject: player!, requiringSecureCoding: false) {
            defaults.set(encodedPlayer, forKey: "player")
        }
    }
    
}
