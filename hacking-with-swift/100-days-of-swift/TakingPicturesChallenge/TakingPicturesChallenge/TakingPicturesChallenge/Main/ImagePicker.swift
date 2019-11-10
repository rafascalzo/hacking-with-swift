//
//  ImagePicker.swift
//  TakingPicturesChallenge
//
//  Created by rafaeldelegate on 11/9/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit

enum CameraResourceOption: String {
    case camera
    case library
    case savedPhotosAlbum
}

public enum CameraError: String, CodingKey{
    case noAccess = "No acess"
}

protocol ImagePickerDelegate {
    func handle(_ image: UIImage)
}

class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: ImagePickerDelegate?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       guard let image = info[.editedImage] as? UIImage  else {
            return
        }
        let imageName = UUID().uuidString
        image.accessibilityIdentifier = imageName
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        delegate?.handle(image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func getImageByID(_ id: String) -> UIImage? {
        let imagePath = getDocumentsDirectory().appendingPathComponent(id)
        return UIImage(contentsOfFile: imagePath.path)
        
    }

}
