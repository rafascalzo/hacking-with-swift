//
//  DetailViewController.swift
//  challenge1
//
//  Created by rafaelviewcontroller on 10/7/19.
//  Copyright © 2019 Rafael Scalzo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var selectedFlag: String!
    
    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(named: selectedFlag)
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleTapped))
        
        
    }
    
    @objc func handleTapped(_ action: UIBarButtonItem) {
        
        guard let image = UIImage(named: selectedFlag) else {
            print("no image found")
            return
        }
        
        let itens = [image]
        
        let vc = UIActivityViewController(activityItems: itens, applicationActivities: [])
        
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
        
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
