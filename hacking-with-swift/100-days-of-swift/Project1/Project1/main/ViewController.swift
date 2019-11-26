//
//  ViewController.swift
//  Project1
//
//  Created by rafaelviewcontroller on 10/1/19.
//  Copyright © 2019 rafaelviewcontroller. All rights reserved.
//

import UIKit

struct Storm : Codable {
    
    let title: String
    var count: Int
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var pictures = [Storm]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellid")
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        performSelector(inBackground: #selector(fetchData), with: nil)
    }
    @objc fileprivate func fetchData() {
        
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "pictures") as? Data {
            print("Agora ta salvo")
            let jsonDecoder = JSONDecoder()
            
            do {
                let pictures = try jsonDecoder.decode([Storm].self, from: savedData)
                self.pictures = pictures
            } catch let error {
                NSLog("%@ \(error.localizedDescription)", " failed to load pictures")
            }
        } else {
            print("sempre tem a primeira vez")
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                if item.hasPrefix("nssl"){
                    let pic = Storm(title: item, count: 0)
                    pictures.append(pic)
                }
            }
            save()
        }
        
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let dataToSave = try? jsonEncoder.encode(pictures) as? Data {
            let defaults = UserDefaults.standard
            defaults.set(dataToSave, forKey: "pictures")
        } else {
            print("failed to save pictures")
        }
    }
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLogedIn")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
        let pic = pictures[indexPath.row]
        cell.textLabel?.text = "\(pic.count)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = DetailViewController()
        let pic = pictures[indexPath.row]
        pictures[indexPath.row].count += 1
        save()
        print(pic.count)
        controller.selectedImage = pic.title
        if let navigation = navigationController {
            navigation.pushViewController(controller, animated: true)
        }
        
    }
}
