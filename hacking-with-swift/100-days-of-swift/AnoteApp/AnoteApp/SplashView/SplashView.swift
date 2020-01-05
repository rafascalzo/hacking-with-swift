//
//  ViewController.swift
//  AnoteApp
//
//  Created by Rafael VSM on 04/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.
//

import UIKit
struct SplashCard {
    var imageName: String
    var text: String
}

private let splashCellIdentifier = "splashCellIdentifier"
class SplashView: UIViewController {
    
    let cards = [SplashCard(imageName: "add-user", text: "convide outras pessoas para ver ou fazer alterações em uma nota."), SplashCard(imageName: "draw-tools", text: "Desenhe usando apenas o seu dedo"), SplashCard(imageName: "documents", text: "Capture documentos, fotos, mapas e muito mais para uma experiência melhor no Anota")]
    @IBOutlet var titleLabel: UILabel!
    
    @IBAction func nextScreen(_ sender: UIButton) {
        User.shared.updateFirstTimeAppear()
        let navigation = UINavigationController(rootViewController: NotesView(nibName: "NotesView", bundle: .main))
        navigation.modalPresentationStyle = .overFullScreen
        present(navigation, animated: true)
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SplashCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: splashCellIdentifier)
        
        titleLabel.numberOfLines = 0
        let text = NSMutableAttributedString(string:
            """
            Bem vindo ao Anota

            Novas ferramentas ótimas para as notas sincronizadas em sua conta do iCloud
            """)
        text.setAttributes([.font: UIFont.systemFont(ofSize: 24)], range: NSRange(location: 0, length: 18))
        text.setAttributes([.font: UIFont.systemFont(ofSize: 12)], range: NSRange(location: 19, length: text.string.count - 19))
        titleLabel.attributedText = text
        
        // Do any additional setup after loading the view.
    }
}

extension SplashView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: splashCellIdentifier, for: indexPath) as! SplashCell
        let selectedCard = cards[indexPath.item]
        
        let image = UIImage(named: selectedCard.imageName)?.withRenderingMode(.alwaysTemplate)
        cell.featureImageView.image = image
        cell.featureImageView.tintColor = UIColor(red: 86/255, green: 86/255, blue: 86/255, alpha: 1)
        cell.featureTextLabel.text = selectedCard.text
        cell.featureTextLabel.font = UIFont.systemFont(ofSize: 12)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
}
