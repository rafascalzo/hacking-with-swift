//
//  TabViewController.swift
//  Project7
//
//  Created by rafaeldelegate on 10/17/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let mainViewcontroller = TableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let firstTabItem = UITabBarItem(title: "Tabela", image: UIImage(systemName: "pencil"), tag: 0)
        //firstTabItem.title = NSLocalizedString("BotonMapas", comment: "comment")
        mainViewcontroller.tabBarItem = firstTabItem
        mainViewcontroller.title = "opaaa"
        
        let tabBarList = [mainViewcontroller]
        viewControllers = tabBarList
       
        // Do any additional setup after loading the view.
    }
}
