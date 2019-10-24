//
//  TableViewController.swift
//  Project7
//
//  Created by rafaeldelegate on 10/17/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
  
    var petitions = [Petition]()
    var selectedPetitions = [Petition]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
//        let urlString: String
//
//                if navigationController?.tabBarItem.tag == 0 {
//                    urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
//                } else {
//                    urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
//                }
//
//
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    if let url = URL(string: urlString) {
//                        if let data = try? Data(contentsOf: url) {
//                            // we're OK to parse!
//                            self?.parse(json: data)
//                            return
//                        }
//                    } else {
//                        self?.showError()
//                    }
//                }
                // might think using weak self to avoid strong references but here isn't necessary cause dispatch wont retain things used inside
                
        //        DispatchQueue.global(qos: .userInitiated).async {
        //            if let url = URL(string: urlString) {
        //                if let data = try? Data(contentsOf: url) {
        //                    // we're OK to parse!
        //                    self.parse(json: data)
        //                    return
        //                }
        //            } else {
        //                self.showError()
        //            }
        //        }
        
        //change implementation with performSelector
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    @objc func fetchJSON() {
        let urlString: String
                
                if navigationController?.tabBarItem.tag == 0 {
                    urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
                } else {
                    urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
                }
                
                
                    if let url = URL(string: urlString) {
                        if let data = try? Data(contentsOf: url) {
                            // we're OK to parse!
                            parse(json: data)
                            return
                        }
                    } else {
                        //showError()
                        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
                    }
                
                // might think using weak self to avoid strong references but here isn't necessary cause dispatch wont retain things used inside
                
        //        DispatchQueue.global(qos: .userInitiated).async {
        //            if let url = URL(string: urlString) {
        //                if let data = try? Data(contentsOf: url) {
        //                    // we're OK to parse!
        //                    self.parse(json: data)
        //                    return
        //                }
        //            } else {
        //                self.showError()
        
        //            }
        //        }
    }
  
    @objc func showError() {
        
//        DispatchQueue.main.async { [weak self] in
//            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "Ok", style: .default))
//            self?.present(ac,animated: true)
//        }
        
        // no required dispatch cause we are using performselector on a main thread
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac,animated: true)
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return petitions.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = DetailViewController()
        controller.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
//            DispatchQueue.main.async { [weak self] in
//                self?.tableView.reloadData()
//            }
            
            // using performSelector on tablewView
            
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
