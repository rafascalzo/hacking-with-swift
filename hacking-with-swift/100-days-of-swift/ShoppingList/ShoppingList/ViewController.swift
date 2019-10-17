//
//  ViewController.swift
//  ShoppingList
//
//  Created by rafaeldelegate on 10/16/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: UITableView.Style.plain)
        return tv
    }()
    var shoppingList = [String]()
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        shoppingList.append("dfsafhdshf adsfhaudsh hduhf adsfh adsufh sdufh sdufh dsufh asdf asdiu hasfu hsduf ahsdf ashdfu asdhf usdhf audhf usdhfaudsfh dsf")
        shoppingList.append("sdfg 5  5s egs 9 d9g 09g 09d8s 0g8df0g u43w98uf -4984uy -4q8urq=0f9q2u3r =qwd09u f2qrdwrw")
        shoppingList.append("shoppingList.append(dfsafhdshf adsfhaudsh hduhf adsfh adsufh sdufh sdufh dsufh asdf asdiu hasfu hsduf ahsdf ashdfu asdhf usdhf audhf usdhfaudsfh dsfshoppingList.append(sdfg 5  5s egs 9 d9g 09g 09d8s 0g8df0g u43w98uf -4984uy -4q8urq=0f9q2u3r =qwd09u f2qrdwrw)")
       // shoppingList.append("as")
        // Do any additional setup after loading the view.
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    
}

