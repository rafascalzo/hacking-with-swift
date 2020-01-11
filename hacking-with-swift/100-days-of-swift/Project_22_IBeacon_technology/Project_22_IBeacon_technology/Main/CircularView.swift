//
//  CircularView.swift
//  Project_22_IBeacon_technology
//
//  Created by Rafael VSM on 11/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CircularView: UIView {
    
    @IBInspectable
    var cornerRadius:CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}
