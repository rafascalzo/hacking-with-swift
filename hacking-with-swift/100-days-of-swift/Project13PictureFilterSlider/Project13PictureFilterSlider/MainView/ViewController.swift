//
//  ViewController.swift
//  Project13PictureFilterSlider
//
//  Created by rafaeldelegate on 11/11/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var radius: UISlider!
    @IBOutlet var angle: UISlider!
    
    var currentImage: UIImage!
    
    var context: CIContext!
    var currentFilter: CIFilter!
    var radiusFilter: CIFilter!
    var angleFilter: CIFilter!
    var gaussianFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        intensity.setValue(0, animated: false)
        angle.setValue(0, animated: false)
        radius.setValue(0, animated: false)
        
        title = "InstaFilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        let image = generateQRCode(from: "Rafael Varanelli Scalzo Moraes")
        imageView.image = image
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }

    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    @IBOutlet var changeFilter: UIButton!
    @IBAction func changeFilter(_ sender: Any) {
        
        let ac = UIAlertController(title: "Choose a filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func setAngleFilter() {
        guard currentImage != nil else {
                          NSLog("Not today bro")
                          return }
               
                      angle.setValue(0, animated: true)
                      angleFilter = CIFilter(name: "CIVortexDistortion")
                      
                      let beginImage = CIImage(image: currentImage)
                      angleFilter.setValue(beginImage, forKey: kCIInputImageKey)
    }
    
    func processAngleFilter() {
           angleFilter.setValue(angle.value * 200, forKey: kCIInputAngleKey)
           
           guard let image = angleFilter.outputImage else { return }
        
           //currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
           
           if let cgImage = context.createCGImage(image, from: image.extent) {
               let processedImage = UIImage(cgImage: cgImage)
               self.imageView.image = processedImage
                currentImage = processedImage
           }
           
           if let cgImage = context.createCGImage(image, from: image.extent) {
               let processedImage = UIImage(cgImage: cgImage)
               imageView.image = processedImage
                currentImage = processedImage
           }
    }
    
    func setRadiusFilter() {
        guard currentImage != nil else {
                   NSLog("Not today bro")
                   return }
        
               radius.setValue(0, animated: true)
               radiusFilter = CIFilter(name: "CITwirlDistortion")
               
               let beginImage = CIImage(image: currentImage)
               radiusFilter.setValue(beginImage, forKey: kCIInputImageKey)
    }
    func processRadiusFilter() {
           radiusFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey)
           
           guard let image = radiusFilter.outputImage else { return }
        
           //currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
           
           if let cgImage = context.createCGImage(image, from: image.extent) {
               let processedImage = UIImage(cgImage: cgImage)
               self.imageView.image = processedImage
            currentImage = processedImage
           }
           
           if let cgImage = context.createCGImage(image, from: image.extent) {
               let processedImage = UIImage(cgImage: cgImage)
               imageView.image = processedImage
            currentImage = processedImage
           }
    }
    @objc func setFilter(action: UIAlertAction! = nil) {
        guard currentImage != nil else {
            NSLog("Not today bro")
            return }
        guard currentFilter != nil else { return }
        guard let actionTitle = action.title else { return }
        intensity.setValue(0, animated: true)
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        changeFilter.setTitle(actionTitle, for: .normal)
        applyProcessing()
    }
    
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Error", message: "No image selected", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(ac, animated: true)
            
            return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    
    @IBAction func radiusChanged(_ sender: Any) {
        processRadiusFilter()
    }
    
    @IBAction func angleChanged(_ sender: Any) {
        processAngleFilter()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError: Error?, contextInfo: UnsafeRawPointer) {
        
        if didFinishSavingWithError != nil {
            let ac = UIAlertController(title: "Save Error", message: didFinishSavingWithError?.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
        
    }
}
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
        imageView.image = currentImage
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        setRadiusFilter()
        setAngleFilter()
        applyProcessing()
    }
    
    func applyProcessing() {
        
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)}
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey)}
        if inputKeys.contains(kCIInputAngleKey) { currentFilter.setValue(intensity.value * 3.14, forKey: kCIInputAngleKey)}
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)}
        if inputKeys.contains(kCIInputCenterKey) { currentFilter .setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)}
        
        guard let image = currentFilter.outputImage else { return }
        //currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        
        if let cgImage = context.createCGImage(image, from: image.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            self.imageView.image = processedImage
            currentImage = processedImage
        }
        
        if let cgImage = context.createCGImage(image, from: image.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
            currentImage = processedImage
        }
    }
}

