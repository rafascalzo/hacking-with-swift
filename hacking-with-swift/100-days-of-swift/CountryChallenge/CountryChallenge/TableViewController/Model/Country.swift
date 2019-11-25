//
//  Country.swift
//  CountryChallenge
//
//  Created by rafaeldelegate on 11/24/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import Foundation

class Country: NSObject, NSCoding, Codable {
    
    var name: String
    var capitalCity: String
    var size: Int
    var population: Int
    var currency: String
    var largestCity: String
    
    init(name: String, capitalCity: String, size: Int, population: Int, currency: String, largestCity: String) {
        self.name = name
        self.capitalCity = capitalCity
        self.size = size
        self.population = population
        self.currency = currency
        self.largestCity = largestCity
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.name = coder.decodeObject(forKey: "name") as? String ?? ""
        self.capitalCity = coder.decodeObject(forKey: "capital_city") as? String ?? ""
        self.size = coder.decodeObject(forKey: "size") as? Int ?? 0
        self.population = coder.decodeObject(forKey: "population") as? Int ?? 0
        self.currency = coder.decodeObject(forKey: "currency") as? String ?? ""
        self.largestCity = coder.decodeObject(forKey: "largest_city") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(capitalCity, forKey: "capital_city")
        coder.encode(size, forKey: "size")
        coder.encode(population, forKey: "population")
        coder.encode(currency, forKey: "currency")
        coder.encode(largestCity, forKey: "largest_city")
    }
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case capitalCity = "capital_city"
        case size = "size_km2"
        case population = "population"
        case currency = "currency"
        case largestCity = "largest_city"
    }
}
