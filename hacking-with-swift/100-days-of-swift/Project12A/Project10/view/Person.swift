//
//  Person.swift
//  Project10
//
//  Created by rafaeldelegate on 11/2/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit
//Many of Apple's own classes support NSCoding, including but not limited to: UIColor, UIImage, UIView, UILabel, UIImageView, UITableView, SKSpriteNode and many more. But your own classes do not, at least not by default. If we want to save the people array to UserDefaults we'll need to conform to the NSCoding protocol.
final class Person: NSObject, NSCoding {
    
    var name: String
    var image: String
    
    init(_ name: String, _ image: String) {
        self.name = name
        self.image = image
    }
    
    init(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        image = coder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(image, forKey: "image")
    }
}
// using required or use final class, required say thet if any class try to sublcass they need to implement this method, saying final its a final class cannot have sublcasses
//class Person: NSObject, NSCoding {
//
//    var name: String
//    var image: String
//
//    init(_ name: String, _ image: String) {
//        self.name = name
//        self.image = image
//    }
//
//    required init?(coder: NSCoder) {
//        name = coder.decodeObject(forKey: "name") as? String ?? ""
//        image = coder.decodeObject(forKey: "image") as? String ?? ""
//    }
//
//    func encode(with coder: NSCoder) {
//        coder.encode(name, forKey: "name")
//        coder.encode(image, forKey: "image")
//    }
//}
