//
//  MalleableView.swift
//  AnoteApp
//
//  Created by Rafael VSM on 04/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.
//

import UIKit

@IBDesignable
final class MalleableButton: UIButton {
    
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
