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
    
    var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
       tableView.register(UINib(nibName: "TableViewCell", bundle: .main), forCellReuseIdentifier: reuseIdentifier)
        
        if let url = Bundle.main.url(forResource: "countries", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                
                if let decoded = try? decoder.decode([Country].self, from: data) {
                    countries = decoded
                    tableView.reloadData()
                } else {
                    print("deu ruim")
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? TableViewCell else { return UITableViewCell()}
        cell.textLabel?.text = countries[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = countries[indexPath.row]
        let controller = DetailViewController(nibName: "DetailViewController", bundle: .main)
        controller.selectedCountry = country
        
        navigationController?.pushViewController(controller, animated: true)
    }
}

