//
//  Note.swift
//  AnoteApp
//
//  Created by Rafael VSM on 05/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.
//

import Foundation

//struct Note: Codable, Hashable {
//
//    var text: String
//
//    static func == (lsh: Note, rhs: Note) -> Bool {
//        return lsh.text == rhs.text
//    }
//}

class Note: NSObject, NSCoding {
    
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.textAttributed == rhs.textAttributed && lhs.title == rhs.title
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(textAttributed, forKey: "textAttibuted")
    }
    
    required init?(coder: NSCoder) {
        self.title = coder.decodeObject(forKey: "title") as? String ?? ""
        self.textAttributed = coder.decodeObject(forKey: "textAttibuted") as? NSAttributedString ?? NSAttributedString()
    }
    
    var title: String
    var textAttributed: NSAttributedString
    
    
    init(_ title: String, _ textAttributed: NSAttributedString) {
        self.title = title
        self.textAttributed = textAttributed
    }
}
