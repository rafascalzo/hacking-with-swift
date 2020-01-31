//
//  Person.swift
//  Project10
//
//  Created by rafaeldelegate on 11/2/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit

class Person: NSObject, NSCoding {
    
    var name: String
    var image: String
    
    init(_ name: String, _ image: String) {
        self.name = name
        self.image = image
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(image, forKey: "image")
       }
       
       required init?(coder: NSCoder) {
        self.name = coder.decodeObject(forKey: "name") as? String ?? ""
        self.image = coder.decodeObject(forKey: "image") as? String ?? ""
       }
}
