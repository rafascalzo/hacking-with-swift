//
//  FolderNotesListView.swift
//  AnoteApp
//
//  Created by Rafael VSM on 05/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.
//



import UIKit
private let folderCellReuseIdentifier = "folderCellReuseIdentifier"

class FolderNotesListView: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "FolderCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: folderCellReuseIdentifier)
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let newFolder = UIBarButtonItem(title: "Nova Pasta", style: .plain, target: self, action: #selector(handleNewFolderTapped))
        newFolder.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.eggYellow], for: .normal)
        toolbarItems = [flexible, newFolder]
        
       let backArrowImage = UIImage(named: "back_arrow")
        let backArrow = UIBarButtonItem(image: backArrowImage, style: .plain, target: self, action: #selector(handleBackArrowTapped))
        backArrow.tintColor = .eggYellow
        
        let notesButton = UIBarButtonItem(title: "Notes", style: .plain, target: self, action: #selector(handleBackArrowTapped))
        notesButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.eggYellow], for: .normal)
        navigationItem.leftBarButtonItems = [backArrow, notesButton]
        
    }
    
    @objc func handleBackArrowTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleNewFolderTapped(_ sender: UIBarButtonItem) {
        print("new folder")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: folderCellReuseIdentifier, for: indexPath) as! FolderCell

        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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
