//
//  Extensions.swift
//  Project10
//
//  Created by rafaeldelegate on 11/2/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
  public class func instantiateViewFromNib<T>(_ nibName: String, inBundle bundle: Bundle = Bundle.main) -> T? {
    if let objects = bundle.loadNibNamed(nibName, owner: nil) {
      for object in objects {
        if let object = object as? T {
          return object
        }
      }
    }

    return nil
  }
}
extension UICollectionViewCell {
    
}
class CollectionViewCell: UIView {
    
var cell: PersonCell!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        cell = Bundle.main.loadNibNamed("CollectionCell", owner: self, options: nil)!.first as! PersonCell
        cell.frame = self.bounds
        cell.autoresizingMask = [.flexibleWidth]
        self.addSubview(cell)
    }
}
