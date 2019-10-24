//
//  TabViewController.swift
//  Project7
//
//  Created by rafaeldelegate on 10/17/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController , UISearchBarDelegate {
    
    let mainViewcontroller = TableViewController()
    lazy var searchBar:UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        searchBar.delegate = self
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let button = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(handleTapped))
        navigationItem.rightBarButtonItem = button
        
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton

        
        let firstTabItem = UITabBarItem(title: "Tabela", image: UIImage(systemName: "pencil"), tag: 0)
        //firstTabItem.title = NSLocalizedString("BotonMapas", comment: "comment")
        mainViewcontroller.tabBarItem = firstTabItem
        mainViewcontroller.title = "opaaa"
        
        let tabBarList = [mainViewcontroller]
        viewControllers = tabBarList
        
        let vc = TableViewController()
        
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 1)
        viewControllers?.append(vc)
       
        // Do any additional setup after loading the view.
    }
    
    @objc func handleTapped(_ sender: UIBarButtonItem) {
        
        let message = selectedIndex == 0 ? "first URL duuude" : "second URL duuude"
        let ac = UIAlertController(title: "Hey there!", message: message, preferredStyle: .alert)
               ac.addAction(UIAlertAction(title: "Ok", style: .default))
               present(ac,animated: true)
    }
    
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let controller = viewControllers?[0] as? TableViewController
        
        for i in 0..<controller!.petitions.count {
            if (controller?.petitions[i].title.contains(String(describing: "\(searchText)")))! {
                print(searchText)
            }
            
        }
    }
}
