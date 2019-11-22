//
//  ViewController.swift
//  CountryChallenge
//
//  Created by rafaeldelegate on 11/21/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit
let reuseIdentifier = "reuseIdentifier"
class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: .main), forCellReuseIdentifier: reuseIdentifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? TableViewCell else { return UITableViewCell()}
        return cell
    }
}

