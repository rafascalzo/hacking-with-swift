//
//  SelectionViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class SelectionViewController: UITableViewController {
    var items = [String]() // this is the array that will store the filenames to load
    //var viewControllers = [UIViewController]() // create a cache of the detail view controllers for faster loading
    var dirty = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Reactionist"
        
        tableView.rowHeight = 90
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // load all the JPEGs into our array
        let fm = FileManager.default
        
        if let tempItems = try? fm.contentsOfDirectory(atPath: Bundle.main.resourcePath!) {
            for item in tempItems {
                //if item.range(of: "Large") != nil {
                //items.append(item)
                //}
                if item.range(of: "Thumb") != nil {
                    items.append(item)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if dirty {
            // we've been marked as needing a counter reload, so reload the whole table
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return items.count * 10
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        //        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "Cell")
        //
        //        if cell == nil {
        //            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        //        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // find the image for this cell, and load its thumbnail
        let currentImage = items[indexPath.row % items.count]
        let imageRootName = currentImage.replacingOccurrences(of: "Large", with: "Thumb")
        
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageRootName)
        let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
        if let image = UIImage(contentsOfFile: imagePath.path) {
            cell.imageView?.image = image
            
            cell.imageView?.layer.shadowColor = UIColor.black.cgColor
            cell.imageView?.layer.shadowOpacity = 1
            cell.imageView?.layer.shadowRadius = 10
            cell.imageView?.layer.shadowOffset = CGSize.zero
            cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: renderRect).cgPath
            print("ja tengo")
        } else if let path = Bundle.main.path(forResource: imageRootName, ofType: nil) {
            if let original = UIImage(contentsOfFile: path) {
                
                //let renderer = UIGraphicsImageRenderer(size: original.size)
                let renderer = UIGraphicsImageRenderer(size: renderRect.size)
                
                let rounded = renderer.image { ctx in
                    
                    //            ctx.cgContext.setShadow(offset: .zero, blur: 200, color: UIColor.black.cgColor)
                    //            ctx.cgContext.fillEllipse(in: CGRect(origin: .zero, size: original.size))
                    //            ctx.cgContext.setShadow(offset: .zero, blur: 0, color: nil)
                    
                    //ctx.cgContext.addEllipse(in: CGRect(origin: CGPoint.zero, size: original.size))
                    ctx.cgContext.addEllipse(in: renderRect)
                    ctx.cgContext.clip()
                    
                    //original.draw(at: CGPoint.zero)
                    original.draw(in: renderRect)
                }
                if let pngData = rounded.pngData() {
                    let imagePath = getDocumentsDirectory().appendingPathComponent(imageRootName)
                    try? pngData.write(to: imagePath)
                }
                cell.imageView?.image = rounded
                
                // give the images a nice shadow to make them look a bit more dramatic
                //        cell.imageView?.layer.shadowColor = UIColor.black.cgColor
                //        cell.imageView?.layer.shadowOpacity = 1
                //        cell.imageView?.layer.shadowRadius = 10
                //        cell.imageView?.layer.shadowOffset = CGSize.zero
                
                cell.imageView?.layer.shadowColor = UIColor.black.cgColor
                cell.imageView?.layer.shadowOpacity = 1
                cell.imageView?.layer.shadowRadius = 10
                cell.imageView?.layer.shadowOffset = CGSize.zero
                cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: renderRect).cgPath
                
                
            }
            
            // each image stores how often it's been tapped
            let defaults = UserDefaults.standard
            cell.textLabel?.text = "\(defaults.integer(forKey: currentImage))"
        }
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ImageViewController()
        vc.image = items[indexPath.row % items.count]
        vc.owner = self
        
        // mark us as not needing a counter reload when we return
        dirty = false
        
        // add to our view controller cache and show
        //viewControllers.append(vc)
        navigationController!.pushViewController(vc, animated: true)
    }
    
    fileprivate func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
