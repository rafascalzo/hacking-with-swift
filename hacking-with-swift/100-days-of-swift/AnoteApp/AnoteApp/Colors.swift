//
//  Colors.swift
//  AnoteApp
//
//  Created by Rafael VSM on 05/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let eggYellow = rgb(r: 245, g: 205, b: 65)
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
