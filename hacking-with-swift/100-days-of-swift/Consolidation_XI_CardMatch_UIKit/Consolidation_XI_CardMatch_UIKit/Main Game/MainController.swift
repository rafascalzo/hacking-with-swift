//
//  MainController.swift
//  Consolidation_XI_CardMatch_UIKit
//
//  Created by Rafael VSM on 09/02/20.
//  Copyright © 2020 Rvsm. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CardCell"

struct Card {
    
    var name: String
    var hasDiscovered: Bool
}

class MainController: UICollectionViewController {
    
    var cards = [Card]()
    var firstCard: String?
    var firstIndex: IndexPath?
    var secondCard: String?
    var secondIndex: IndexPath?
    var usedCards = 0
    var start: CFAbsoluteTime!
    var bestTime = CGFloat.infinity {
        didSet {
            timeLabel.text = "Best Time: \(String(format: "%.2f", bestTime))"
        }
    }
    
    var timeLabel: UILabel = {
       let lb = UILabel()
        lb.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 30))
        return lb
    }()
    var roundCount = 1 {
        didSet {
            title = "Round \(roundCount)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        roundCount = 1
        
        let leftButton = UIBarButtonItem(customView: timeLabel)
        navigationItem.leftBarButtonItem = leftButton
        bestTime = CGFloat.infinity
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(GameCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        ["Aces"].forEach { prefix in
            ["Clubs","Hearts","Spades","Diamonds"].forEach { suffix in
                cards.append(Card(name: "\(prefix)_\(suffix)", hasDiscovered: false))
                cards.append(Card(name: "\(prefix)_\(suffix)", hasDiscovered: false))
            }
        }
        start = CFAbsoluteTimeGetCurrent()
        self.cards = cards.shuffled()
        collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cards.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GameCell
        let cardName = cards[indexPath.item].name
        cell.cardImageView.image = UIImage(named: cardName)
        cell.backCardImageView.image = UIImage(named: "blue_back")
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */
     
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !cards[indexPath.item].hasDiscovered else { return }
        if firstIndex != nil {
            if indexPath == firstIndex {
                return
            }
        }
        collectionView.isUserInteractionEnabled = false
        if firstCard == nil {
            firstCard = cards[indexPath.item].name
            firstIndex = indexPath
        } else {
            secondCard = cards[indexPath.item].name
            secondIndex = indexPath
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! GameCell
        cell.perform(#selector(cell.flip))
        
        if firstCard != nil && secondCard != nil {
            if firstCard == secondCard {
                cards[firstIndex!.item].hasDiscovered = true
                cards[secondIndex!.item].hasDiscovered = true
                usedCards += 2
                firstCard = nil
                firstIndex = nil
                secondCard = nil
                secondIndex = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
                    self?.collectionView.isUserInteractionEnabled = true
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [unowned self] in
                    let firstCell = collectionView.cellForItem(at: self.firstIndex!)
                    firstCell?.perform(#selector(cell.flip))
                    cell.perform(#selector(cell.flip))
                    self.firstCard = nil
                    self.firstIndex = nil
                    self.secondCard = nil
                    self.secondIndex = nil
                    collectionView.isUserInteractionEnabled = true
                }
            }
            firstCard = nil
            secondCard = nil
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
                self?.collectionView.isUserInteractionEnabled = true
            }
        }
        
        if usedCards == 8 {
            let time = CFAbsoluteTimeGetCurrent() - start
            let formatedTime = String(format: "%.2f", time)
            if CGFloat(time) < bestTime {
                bestTime = CGFloat(time)
            }
            let ac = UIAlertController(title: "You win!", message: "Time: \(formatedTime)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: handleOk))
            present(ac, animated: true)
        }
    }
    
    @objc func handleOk(_ action: UIAlertAction! = nil) {
        collectionView.isUserInteractionEnabled = false
        let max = collectionView.numberOfItems(inSection: 0)
        for i in 0..<max {
            let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as! GameCell
            cell.perform(#selector(cell.flip))
        }
        for j in 0..<cards.count {
            cards[j].hasDiscovered = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.cards = self?.cards.shuffled() ?? []
            self?.usedCards = 0
            self?.collectionView.reloadData()
            self?.collectionView.isUserInteractionEnabled = true
            self?.start = CFAbsoluteTimeGetCurrent()
            self?.roundCount += 1
        }
    }
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}

extension MainController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 100)
    }
}
