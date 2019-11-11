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
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddBarButtonTapped))
        self.navigationItem.leftBarButtonItem = addButton
        tableView.register(UINib(nibName: "PictureCell", bundle: nil), forCellReuseIdentifier: picturesReuseID)
        
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "pictures") as? Data {
            let decoder = JSONDecoder()
            if let pictures = try? decoder.decode([[Picture]].self, from: savedData) {
                self.pictures = pictures
            }
        }
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
        print(item.image)
        let image = imagePicker.getImageByID(item.image)
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.caption
        cell.imageView?.image = image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = DetailViewController(nibName: "DetailViewController", bundle: nil)
        let picture = pictures[indexPath.section][indexPath.row]
        print(picture)
        controller.picture = picture
        
        navigationController?.pushViewController(controller, animated: true)
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
    
    
    
}

extension PicturesView: ImagePickerDelegate {
    func handle(_ image: UIImage) {
        var title: String = ""
        var caption: String = ""
        let ac = UIAlertController(title: "Photo Settins", message: "Enter a name and a caption for your photo!", preferredStyle: .alert)
        ac.addTextField()
        ac.addTextField()
        ac.textFields![0].placeholder = "Title"
        ac.textFields![1].placeholder = "Caption"
        
        for textField in ac.textFields! {
//            let bottomLine = CALayer()
//            bottomLine.frame = CGRect(x: 0, y: 0, width: textField.frame.width, height: 1)
//            bottomLine.backgroundColor = UIColor.black.cgColor
//            bottomLine.borderColor = UIColor.black.cgColor
//            textField.borderStyle = .none
//            textField.layer.addSublayer(bottomLine)
            textField.borderStyle = .roundedRect
        }
        
        let save = UIAlertAction(title: "Save", style: .default) { [weak self] (_) in
            let textFields = ac.textFields!
            title = textFields[0].text ?? ""
            caption = textFields[1].text ?? ""
            guard let imagename = image.accessibilityIdentifier else { return }
            let picture = Picture(image: imagename, title: title, caption: caption, date: Date())
            self?.save(picture: picture)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(save)
        ac.addAction(cancel)
        
        present(ac, animated: true, completion: nil)
        
    }
    
    func save(picture: Picture ) {
        let pics = [picture]
        pictures.append(pics)
        
        let defaults = UserDefaults.standard
        
        let encoder = JSONEncoder()
        
        if let dataToSave = try? encoder.encode(pictures) {
            defaults.set(dataToSave, forKey: "pictures")
        }
        tableView.reloadData()
    }
    
    
}
