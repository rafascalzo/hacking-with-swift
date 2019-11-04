//
//  CollectionViewController.swift
//  Project10
//
//  Created by rafaeldelegate on 11/2/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Person"

class CollectionViewController: UICollectionViewController {
    
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "PersonCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Person] {
                people = decodedPeople
            }
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

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
            self?.save()
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
    
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
            
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        let ac = UIAlertController(title: "What you want to do?", message: nil, preferredStyle: .alert)
        
        let rename = UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            self?.renamePerson(person)
            self?.save()
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
        save()
        collectionView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
