//
//  ImageViewCell.swift
//  Project_25_ Multipeer_Connectivity
//
//  Created by Rafael VSM on 20/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.backgroundColor = .red
        backgroundColor = .yellow
        // Initialization code
    }

}
