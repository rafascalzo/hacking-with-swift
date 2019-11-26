//
//  ViewController.swift
//  Project18Debug
//
//  Created by rafaeldelegate on 11/25/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Im in viewDidLoad() method")
        print(1,2,3,4,5)
        print(7,8,9,10,11, separator: "-")
        print(12,13,14,15,16, terminator: "")
        assert(1 == 1, "Math failure!")
        //assert(1==2, "Math failure!")
        //assert(myReallySlowMethod() == true, "The slow method returned false, wich is a bad thing")
        
        for i in 1 ... 100 {
            print("Got number \(i)")
        }
        
    }


}

