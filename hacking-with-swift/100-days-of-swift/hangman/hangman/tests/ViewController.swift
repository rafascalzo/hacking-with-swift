//
//  ViewController.swift
//  hangman
//
//  Created by rafaeldelegate on 10/26/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit

class LetterCell: UICollectionViewCell {
    
    var letter: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 36)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 23/255, green: 23/255, blue: 23/255, alpha: 0.87)
    }
    
    func addletter(_ letter: String) {
        self.letter.text = letter
        addSubview(self.letter)
        
        let viewsDictionary = ["v0":self.letter]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class HangmanController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return letters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "letterID", for: indexPath) as! LetterCell
        cell.layer.cornerRadius = 25
        cell.addletter(letters[indexPath.row])
        return cell
    }
    
    var words = [String]()
    var letters = [String]()
   
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .lightGray
        return cv
    }()
    
    lazy var button: UIButton = {
       let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(handleTapped), for: .touchUpInside)
        btn.setTitle("Manda Ve", for: .normal)
        btn.layer.cornerRadius = 12
        return btn
    }()
    
    @objc func handleTapped(_ sender: UIButton) {
        letters = [String]()
       guard let randomWord = words.randomElement() else { return }
              for letter in randomWord {
                  letters.append(String(letter))
              }
              collectionView.reloadData()
    }
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        collectionView.register(LetterCell.self, forCellWithReuseIdentifier: "letterID")
        
        view.addSubview(button)
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = Bundle.main.url(forResource: "hangmans-words", withExtension: "txt") else {
            print("o mano fudeo aqui na linha 25")
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
        
        guard let randomWord = words.randomElement() else { return }
        for letter in randomWord {
            letters.append(String(letter))
        }
        collectionView.reloadData()
        // Do any additional setup after loading the view.
    }
}
