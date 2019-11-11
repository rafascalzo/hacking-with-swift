//
//  DetailViewController.swift
//  TakingPicturesChallenge
//
//  Created by rafaeldelegate on 11/10/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var picture: Picture!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var captionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(picture)
        imageView.image = ImagePicker().getImageByID(picture.image)
        titleLabel.text = picture.title
        captionLabel.text = picture.caption
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
