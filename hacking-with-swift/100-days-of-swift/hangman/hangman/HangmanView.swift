//
//  HangmansView.swift
//  hangman
//
//  Created by rafaeldelegate on 10/28/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit

class HangmanView: UIViewController {
    
    var words = [String]()
    var letters = [String]()
    var labels = [UILabel]()
    var selectedWord: String!
    
    var label: UILabel!
    var textField: UITextField!
    var containerView: UIView!
    var submitButton: UIButton!
    
    override func loadView() {
        super.loadView()
        view = UIView()
        view.backgroundColor = .white
        
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40)
        label.text = "Pick a letter"
        
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "A"
        
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        submitButton = UIButton()
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.layer.cornerRadius = 25
        submitButton.backgroundColor = .systemBlue
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        view.addSubview(label)
        view.addSubview(textField)
        view.addSubview(containerView)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            label.widthAnchor.constraint(equalTo: view.widthAnchor),
            label.heightAnchor.constraint(equalToConstant: 50),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor),
            textField.heightAnchor.constraint(equalToConstant: 50),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            containerView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 300),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            submitButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = Bundle.main.url(forResource: "hangman-words", withExtension: "txt") else {
            print("wrong path")
            return }
        
        do {
            let data = try String(contentsOf: url)
            let lines = data.components(separatedBy: "\n")
            
            for line in lines {
                words.append(line.uppercased())
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        selectedWord = words.randomElement()
        setupLetters(selectedWord)
        for _ in selectedWord {
            letters.append("?")
        }
    }
    @objc func submitTapped(_ sender: UIButton) {
        guard let inputLetter = textField.text?.uppercased() else { return }
        for (index, letter) in selectedWord.enumerated() {
            if letter.description == inputLetter {
                labels[index].text = inputLetter
            }
        }
    }
    func setupLetters(_ selectedWord: String) {
        
        for _ in selectedWord {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "?"
            label.backgroundColor = . yellow
            labels.append(label)
        }
        
        var previous: UILabel?
        for label in labels {
            
            containerView.addSubview(label)
            
            if let previous = previous {
                label.leadingAnchor.constraint(equalTo: previous.trailingAnchor, constant: 2).isActive = true
            } else {
                label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
            }
            
            label.widthAnchor.constraint(equalToConstant: 20).isActive = true
            label.heightAnchor.constraint(equalToConstant: 20).isActive = true
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            
            previous = label
        }
    }
    
}
