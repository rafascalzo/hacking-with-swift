//
//  MainViewController.swift
//  Project2
//
//  Created by rafaelviewcontroller on 10/3/19.
//  Copyright © 2019 rafaelviewcontroller. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var firstButton: UIButton!
    @IBOutlet var secondButton: UIButton!
    @IBOutlet var thirdButton: UIButton!
    
    var countries = [String]()
    var score = 0
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
        let alert = UIAlertController(title: "Score", message: "Your score is \(score)", preferredStyle: .alert)
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
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1;
            labelScore.text = "Score \(score)"
            alertMessage = "Correct! Thats the flag of \(countries[sender.tag])"
        } else {
            title = "Wrong"
            alertMessage = "Wrong! Thats the flag of \(countries[sender.tag])"
        }
        questionNumber += 1
        
        var alert = UIAlertController(title: title, message: alertMessage, preferredStyle: .alert)
        
        if questionNumber == 10 {
            alert = UIAlertController(title: title, message: "Your final score is \(score)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Reset Game", style: .default))
            labelScore.text = "Score 0"
            score = 0
            questionNumber = 0
        } else {
            
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        }
        
        
        present(alert, animated: true)
    }
    
}
