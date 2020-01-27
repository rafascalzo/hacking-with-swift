//
//  ViewController.swift
//  Consolidation_X_Meme_Generator
//
//  Created by Rafael VSM on 25/01/20.
//  Copyright © 2020 Rafael Scalzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func shareMeme(_ sender: Any) {
        guard imageView.image != nil else {
            let ac = UIAlertController(title: "No image selected", message: "You need create a meme to share", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            present(ac, animated: true)
            return
        }
        if let dataImage = imageView.image?.pngData() {
            share(itens: dataImage)
        }
    }
    
    @IBAction func addTitle(_ sender: Any) {
        guard let image = safeImage else { return }
        let ac = UIAlertController(title: "Meme title", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let ok = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            let tf = ac.textFields!.first!
            guard tf.text != nil, tf.text != "" ,let text = tf.text else {
                self?.addMeme(image: image)
                return
            }
            self?.memeTitle = text.uppercased()
            self?.addMeme(image: image, title: self?.memeTitle, subtitle: self?.memeSubtitle)
        }
        ac.addAction(ok)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(cancel)
        
        present(ac, animated: true)
    }
    
    @IBAction func addSubtitle(_ sender: Any) {
        
        guard let image = safeImage else { return }
        
        let ac = UIAlertController(title: "Meme subtitle", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let ok = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            let tf = ac.textFields!.first!
            guard tf.text != nil, tf.text != "" ,let text = tf.text else {
                self?.addMeme(image: image)
                return
            }
            self?.memeSubtitle = text.uppercased()
            self?.addMeme(image: image, title: self?.memeTitle, subtitle: self?.memeSubtitle)
        }
        ac.addAction(ok)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(cancel)
        
        present(ac, animated: true)
    }
    
    var memeTitle: String?
    var memeSubtitle: String?
    var safeImage: UIImage?
    
    func share(itens: Any...) {
        
        var itensToShow = [Any]()
        
        for item in itens {
            if let data = item as? Data {
                itensToShow.append(data)
            }
            if let string = item as? String {
                itensToShow.append(string)
            }
        }
        let controller = UIActivityViewController(activityItems: itensToShow, applicationActivities: [])
        controller.popoverPresentationController?.sourceView = imageView
        present(controller, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        test()
        title = "Meme generator"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(handleCameraTapped))
    }
    
    @objc func handleCameraTapped() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.sourceType = .photoLibrary
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            picker.sourceType = .savedPhotosAlbum
        }
        present(picker, animated: true)
    }
    
    func test() {
        // The #if swift directive allows you to conditionally compile code depending on the Swift compiler version being used.
        // situations
        // You create a library that you distribute as Swift source code. Supporting more than one version of Swift helps reduce complexity for your users without breaking their code.
        // You want to experiment with a future version of Swift without breaking your existing code. Having both in the same file means you can toggle between them easily enough.
        #if swift(>=5.0)
        print("Running Swift 5.0 or later")
        #else
        print("Running Swift 4.2")
        #endif
        
        /*
         #file          String   The name of the file in which it appears.
         #line          Int      The line number on which it appears.
         #column        Int      The column number in which it begins.
         #function      String   The name of the declaration in which it appears.
         #dsohandle     UnsafeMutablePointer   The dso handle.
         */
        print(#function, #line, #file, #column, #dsohandle)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        safeImage = image
        imageView.image = image
        picker.dismiss(animated: true)
    }
    

    
    func addMeme(image: UIImage, title: String? = nil, subtitle: String? = nil) {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: imageView.bounds.size)
            
            let image = renderer.image { context in
               
                image.draw(in: imageView.bounds)
                
                if let title = title {
                    let shadow = NSShadow()
                    shadow.shadowOffset = CGSize(width: 3, height: 3)
                    shadow.shadowColor = UIColor.black
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center
                    
                    let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 30), .foregroundColor: UIColor.white, .shadow: shadow, .paragraphStyle: paragraphStyle]
                    let attributedString = NSAttributedString(string: title, attributes: attributes)
                    attributedString.draw(with: CGRect(origin: CGPoint(x: imageView.bounds.minX, y: imageView.bounds.minY + 5), size: CGSize(width: imageView.bounds.width, height: 50)), options: .usesLineFragmentOrigin, context: nil)
                }
                
                if let subtitle = subtitle {
                    let shadow = NSShadow()
                    shadow.shadowOffset = CGSize(width: 3, height: 3)
                    shadow.shadowColor = UIColor.black
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center
                    paragraphStyle.lineBreakMode = .byWordWrapping
                    
                    let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 30), .foregroundColor: UIColor.white, .shadow: shadow, .paragraphStyle: paragraphStyle]
                    let attributedString = NSAttributedString(string: subtitle, attributes: attributes)
                    attributedString.draw(with: CGRect(origin: CGPoint(x: imageView.bounds.minX, y: imageView.bounds.maxY - 100), size: CGSize(width: imageView.bounds.width, height: 100)), options: .usesLineFragmentOrigin, context: nil)
                }
            }
            imageView.image = image
        } else {
            //UIGraphicsBeginImageContextWithOptions(). This starts a new Core Graphics rendering pass. Pass it your size, then a rendering scale, and whether the image should be opaque. If you want to use the current device’s scale, use 0 for the scale parameter.
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 512, height: 512), false, 0)
            
            //Just starting a rendering pass doesn’t give you a context. To do that, you need to use UIGraphicsGetCurrentContext(), which returns a CGContext?. It’s optional because of course Swift doesn’t know we just started a rendering pass.
            if let _ = UIGraphicsGetCurrentContext() {
                image.draw(in: imageView.bounds)
                
                if let title = title {
                    let shadow = NSShadow()
                    shadow.shadowOffset = CGSize(width: 3, height: 3)
                    shadow.shadowColor = UIColor.black
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center
                    
                    let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 30), .foregroundColor: UIColor.white, .shadow: shadow, .paragraphStyle: paragraphStyle]
                    let attributedString = NSAttributedString(string: title, attributes: attributes)
                    attributedString.draw(with: CGRect(origin: CGPoint(x: imageView.bounds.minX, y: imageView.bounds.minY + 5), size: CGSize(width: imageView.bounds.width, height: 50)), options: .usesLineFragmentOrigin, context: nil)
                }
                
                if let subtitle = subtitle {
                    let shadow = NSShadow()
                    shadow.shadowOffset = CGSize(width: 3, height: 3)
                    shadow.shadowColor = UIColor.black
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center
                    paragraphStyle.lineBreakMode = .byWordWrapping
                    
                    let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 30), .foregroundColor: UIColor.white, .shadow: shadow, .paragraphStyle: paragraphStyle]
                    let attributedString = NSAttributedString(string: subtitle, attributes: attributes)
                    attributedString.draw(with: CGRect(origin: CGPoint(x: imageView.bounds.minX, y: imageView.bounds.maxY - 100), size: CGSize(width: imageView.bounds.width, height: 100)), options: .usesLineFragmentOrigin, context: nil)
                }
            }
            //Call UIGraphicsGetImageFromCurrentImageContext() when you want to extract a UIImage from your rendering. Again, this returns an optional (in this case UIImage?) because Swift doesn’t know a rendering pass is active.
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                imageView.image = image
            }
            //Call UIGraphicsEndImageContext() when you’ve finished, to free up the memory from your rendering.
            UIGraphicsEndImageContext()
        }
    }
}
