//
//  ViewController.swift
//  Project1
//
//  Created by rafaelviewcontroller on 10/1/19.
//  Copyright © 2019 rafaelviewcontroller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var tableView: UITableView!
    var pictures = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl"){
                pictures.append(item)
            }
        }
        print(pictures)
        
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true); tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Picture")
//
//    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Picture")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    
}

