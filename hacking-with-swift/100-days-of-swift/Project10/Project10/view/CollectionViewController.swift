//
//  CollectionViewController.swift
//  Project10
//
//  Created by rafaeldelegate on 11/2/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit
import LocalAuthentication

private let reuseIdentifier = "Person"
private let peopleKey = "peopleKey"

class CollectionViewController: UICollectionViewController {
    
    var people = [Person]()
    
    func unlockSavedData() {
        let keychainWrapper = KeychainWrapper.standard
        if let savedData = keychainWrapper.data(forKey: peopleKey) {
            if let savedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Person] {
                print(savedPeople.count)
                print(people.count)
                people = savedPeople
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } else {
                print("failed to unarchive")
            }
        } else {
            print("no data")
        }
    }
    var leftBarButtonItem: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "PersonCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .lightGray
        view.backgroundColor = .lightGray
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Authenticate", style: .plain, target: self, action: #selector(handleAuthenticateTapped))
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(saveState), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func handleAuthenticateTapped() {
        
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                if success {
                    self?.unlockSavedData()
                    DispatchQueue.main.async {
                        self?.navigationItem.leftBarButtonItem = self?.leftBarButtonItem
                    }
                } else {
                    let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(ac, animated: true)
                }
            }
        }
    }
    
    @objc func saveState() {
        if let dataToSave = try? NSKeyedArchiver.archivedData(withRootObject: self.people, requiringSecureCoding: false) {
            let keichainWrapper = KeychainWrapper.standard
            keichainWrapper.set(dataToSave, forKey: peopleKey)
            print(people.count)
        } else {
            print("no data to save")
        }
    }
    
    @objc func addNewPerson(_ sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        present(picker, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PersonCell else {
            fatalError("Unable to dequee PersonCell")
        }
        let person = people[indexPath.item]
        cell.name.text = person.name
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        let image = UIImage(contentsOfFile: path.path)
        cell.imageView.image = image
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    fileprivate func renamePerson(_ person: Person) {
        let ac = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let ok = UIAlertAction(title: "Ok", style: .default) { [weak self, weak ac] action in
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName
            self?.collectionView.reloadData()
        }
        ac.addAction(ok)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cancel)
        
        present(ac, animated: true, completion: nil)
    }
    fileprivate func delete(_ person: Person) {
        
        people.removeAll { (actualPerson) -> Bool in
            if person == actualPerson {
                return true
            }
            return false
        }
        collectionView.reloadData()
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        let ac = UIAlertController(title: "What you want to do?", message: nil, preferredStyle: .alert)
        
        let rename = UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            self?.renamePerson(person)
        }
        let delete = UIAlertAction(title: "Delete", style: .default) { [weak self](_) in
            print("deleting person")
            self?.delete(person)
            
        }
        ac.addAction(rename)
        ac.addAction(delete)
        present(ac, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension CollectionViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person("Rafael", imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
