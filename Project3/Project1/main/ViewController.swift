//
//  ViewController.swift
//  Project1
//
//  Created by rafaelviewcontroller on 10/1/19.
//  Copyright © 2019 rafaelviewcontroller. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet var tableView: UITableView!
    
    var pictures = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellid")
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl"){
                pictures.append(item)
            }
        }
        
    }
    
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLogedIn")
    }
    
    @objc func shareTapped(_ action: UIBarButtonItem) {
        
        let itens:[Any] = ["Go to", URL(string: "https://www.twitter.com")!, " and found me"]
        
        let vc = UIActivityViewController(activityItems: itens, applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc,animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = DetailViewController()
        controller.selectedImage = pictures[indexPath.row]
        if let navigation = navigationController {
            navigation.pushViewController(controller, animated: true)
        }
        
    }
}
