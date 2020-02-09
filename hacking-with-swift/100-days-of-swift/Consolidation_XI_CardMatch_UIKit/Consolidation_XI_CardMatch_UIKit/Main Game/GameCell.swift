//
//  GameCell.swift
//  Consolidation_XI_CardMatch_UIKit
//
//  Created by Rafael VSM on 09/02/20.
//  Copyright © 2020 Rvsm. All rights reserved.
//
/*
 Option 2: Leading and trailing anchors always refer to the left and right edge of the screen.
 In right-to-left languages such as Arabic, the leading constraint is on the right edge of the screen, and the trailing constraint is on the left.
 */
import UIKit
private let cellReuseIdentifier = "CardCell"

class GameCell: UICollectionViewCell {
    
    var cardImageView: UIImageView!
    var backCardImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backCardImageView = UIImageView()
        backCardImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backCardImageView)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":backCardImageView!]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":backCardImageView!]))
        
        cardImageView = UIImageView()
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.isHidden = true
        addSubview(cardImageView)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":cardImageView!]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":cardImageView!]))
        
        
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
