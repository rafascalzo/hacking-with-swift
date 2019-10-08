//
//  ViewController.swift
//  challenge1
//
//  Created by rafaelviewcontroller on 10/7/19.
//  Copyright © 2019 Rafael Scalzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    let cellId = "cellId"
    var imageNames = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.resourcePath!
        let fm = FileManager.default
        let itens = try! fm.contentsOfDirectory(atPath: path)
        
        for item in itens{
            if item.hasSuffix(".png") {
                print(item)
                imageNames.append(item)
            }
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)

        // Do any additional setup after loading the view.
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.prepareForReuse()
        cell.imageView?.image = UIImage(named: imageNames[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = DetailViewController()
        controller.selectedFlag = imageNames[indexPath.row]
        if let navigation = navigationController{
            navigation.pushViewController(controller, animated: true)
        }
        
    }
}
