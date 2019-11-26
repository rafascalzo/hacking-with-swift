//
//  DetailViewController.swift
//  Project1
//
//  Created by rafaelviewcontroller on 10/1/19.
//  Copyright © 2019 rafaelviewcontroller. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(selectedImage != nil, "selectedImage are nil!")
        title = selectedImage
        navigationItem.largeTitleDisplayMode = .never
        
        if let imageName = selectedImage{
            imageView.image = UIImage(named: imageName)
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
