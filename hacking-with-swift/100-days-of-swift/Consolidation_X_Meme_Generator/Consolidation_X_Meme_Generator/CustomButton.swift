//
//  CustomButton.swift
//  Consolidation_X_Meme_Generator
//
//  Created by Rafael VSM on 25/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.
//

import UIKit
@IBDesignable
class CustomButton: UIButton {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
}
