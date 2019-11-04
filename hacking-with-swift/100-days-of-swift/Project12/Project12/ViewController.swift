//
//  ViewController.swift
//  Project12
//
//  Created by rafaeldelegate on 11/3/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let defaults = UserDefaults.standard
        defaults.set(25, forKey: "Age")
        defaults.set(true, forKey: "UseFaceID")
        defaults.set(CGFloat.pi, forKey: "pi")
        defaults.set("Rafael Scalzo", forKey: "Name")
        defaults.set(Date(), forKey: "LastRun")
        
        let array = ["Rafael","Scalzo"]
        defaults.set(array, forKey: "SavedArray")
        
        let dict = ["Name": "Rafael", "Country": "BR"]
        defaults.set(dict, forKey: "SavedDict")
        
        let savedInteger = defaults.integer(forKey: "Age")
        let savedBool = defaults.bool(forKey: "UseFaceID")
        let savedArray = defaults.object(forKey:"SavedArray") as? [String] ?? [String]()
        let savedDict = defaults.object(forKey: "SavedDict") as? [String: String] ?? [String: String]()
        print(savedInteger)
        print(savedBool)
        print(savedArray)
        print(savedDict)
        
    }


}

