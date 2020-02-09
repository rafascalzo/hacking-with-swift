//
//  GameCell.swift
//  Consolidation_XI_CardMatch_UIKit
//
//  Created by Rafael VSM on 09/02/20.
//  Copyright © 2020 Rvsm. All rights reserved.
//

import UIKit
private let cellReuseIdentifier = "CardCell"

class GameCell: UICollectionViewCell {
    
    var cardImageView: UIImageView!
    var backCardImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cardImageView = UIImageView()
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cardImageView)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":cardImageView!]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":cardImageView!]))
        
        backCardImageView = UIImageView()
        backCardImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backCardImageView)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":backCardImageView!]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":backCardImageView!]))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        cardImageView.image = nil
    }
    
    override var reuseIdentifier: String? {
        return cellReuseIdentifier
    }
    
    @objc func flip() {
        let firstTransition: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        let secondTransition: UIView.AnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
        if !backCardImageView.isHidden {
            UIView.transition(with: backCardImageView, duration: 1.0, options: firstTransition, animations: {
                self.backCardImageView.isHidden = true
            })
            UIView.transition(with: cardImageView, duration: 1.0, options: firstTransition, animations: {
                self.cardImageView.isHidden = false
            })
        } else {
            UIView.transition(with: cardImageView, duration: 1.0, options: secondTransition, animations: {
                self.cardImageView.isHidden = true
            })
            UIView.transition(with: backCardImageView, duration: 1.0, options: secondTransition, animations: {
                self.backCardImageView.isHidden = false
            })
        }
        
    }
}
