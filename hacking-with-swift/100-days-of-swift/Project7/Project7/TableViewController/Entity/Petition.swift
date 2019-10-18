//
//  Petition.swift
//  Project7
//
//  Created by rafaeldelegate on 10/17/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

struct Petitions: Codable {
    var results: [Petition]
}
