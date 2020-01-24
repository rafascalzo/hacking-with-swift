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
        
        title = selectedImage
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
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
    @objc func shareTapped(_ action: UIBarButtonItem) {
        
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("no image found")
            return
        }
        guard let imageName = selectedImage else {
            print("no found name")
            return
        }
        share(itens: image,imageName)
       
    }
}

extension UIViewController {
    
       func share(itens: Any...) {
              var itensToShow = [Any]()
              for item in itens {
                  print(type(of: item))
                  if let dataItem = item as? Data {
                      itensToShow.append(dataItem)
                  }
                  
                  if let string = item as? String {
                      itensToShow.append(string)
                  }
                  
                  if let imageView = item as? UIImageView {
                      guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
                          print("no image found")
                          return
                      }
                      itensToShow.append(image)
                  }
              }
              
              let vc = UIActivityViewController(activityItems: itensToShow, applicationActivities: [])
              vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
              present(vc,animated: true)
          }
}
