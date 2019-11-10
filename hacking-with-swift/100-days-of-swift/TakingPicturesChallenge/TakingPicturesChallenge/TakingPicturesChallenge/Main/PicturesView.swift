//
//  PicturesView.swift
//  TakingPicturesChallenge
//
//  Created by rafaeldelegate on 11/7/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit

struct Picture: Codable {
    
    let image: String
    let title: String
    let caption: String
    let date: Date
}

let picturesReuseID = "Picture"

class PicturesView: UITableViewController {
    
    var pictures = [[Picture]]()
  let imagePicker = ImagePicker()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddBarButtonTapped))
        self.navigationItem.leftBarButtonItem = addButton
        tableView.register(UINib(nibName: "PictureCell", bundle: nil), forCellReuseIdentifier: picturesReuseID)
        
//        for i in 0..<7 {
//            var pics = [Picture]()
//            for j in 0..<Int.random(in: 2...7) {
//                let pic = Picture(image: "oi", title: "thua", caption: "breve descicaode sas porra", date: Date())
//                pics.append(pic)
//            }
//            pictures.append(pics)
//        }
        
        
    }
    
    @objc func handleAddBarButtonTapped(action: UIBarButtonItem? = nil) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        imagePicker.delegate = self
        picker.delegate = imagePicker
        present(picker, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pictures[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: picturesReuseID, for: indexPath) as? PictureCell else {
            return UITableViewCell()
        }
        let item = pictures[indexPath.section][indexPath.row]
        let randomDay = String.getHour(from: item.date, withFormat: .hourAndMinutesPMFormat)
        print(item.image)
        let image = imagePicker.getImageByID(item.image)
        cell.textLabel?.text = "Fada Linda \(randomDay)"
        cell.imageView?.image = image
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

extension PicturesView: ImagePickerDelegate {
    func handle(_ image: UIImage) {
        guard let imagename = image.accessibilityIdentifier else { return }
        print(imagename)
        let picture = Picture(image: imagename, title: "Fada Delicia", caption: "Gostosa", date: Date())
        let pics = [picture]
        pictures.append(pics)
        tableView.reloadData()
        
    }
    
    
}
