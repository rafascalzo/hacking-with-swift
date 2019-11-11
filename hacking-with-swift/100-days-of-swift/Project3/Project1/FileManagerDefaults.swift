//
//  FileManagerDefaults.swift
//  Project1
//
//  Created by rafaeldelegate on 11/10/19.
//  Copyright © 2019 rafaelviewcontroller. All rights reserved.
//

import Foundation
public class FileManagerDefaults {
    
    static var fileManager: FileManager {
      return FileManager.default
    }
    static var path: String {
        return Bundle.main.resourcePath!
    }
    static func getResourcePathWith(_ prefix: String) -> [String] {
        var itens = [String]()
        
        let items = try! fileManager.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix(prefix){
                itens.append(item)
            }
        }
        return itens
    }
}
