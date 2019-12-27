//
//  ActionViewController.swift
//  Extension
//
//  Created by Fulltrack Mobile on 26/12/19.
//  Copyright © 2019 Rafael Scalzo. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        //When our extension is created, its extensionContext lets us control how it interacts with the parent app. In the case of inputItems this will be an array of data the parent app is sending to our extension to use. We only care about this first item in this project, and even then it might not exist, so we conditionally typecast using if let and as?.
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            //Our input item contains an array of attachments, which are given to us wrapped up as an NSItemProvider. Our code pulls out the first attachment from the first input item.
            if let itemProvider = inputItem.attachments?.first {
                //The next line uses loadItem(forTypeIdentifier: ) to ask the item provider to actually provide us with its item, but you'll notice it uses a closure so this code executes asynchronously. That is, the method will carry on executing while the item provider is busy loading and sending us its data.
                
                
                //Inside our closure we first need the usual [weak self] to avoid strong reference cycles, but we also need to accept two parameters: the dictionary that was given to us by the item provider, and any error that occurred.
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    //With the item successfully pulled out, we can get to the interesting stuff: working with the data.
                    // do stuff
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    print(javaScriptValues)
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    //This is needed because the closure being executed as a result of loadItem(forTypeIdentifier:) could be called on any thread, and we don't want to change the UI unless we're on the main thread.
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                    //You might have noticed that I haven't written [weak self] in for the async() call, and that's because it's not needed. The closure will capture the variables it needs, which includes self, but we're already inside a closure that has declared self to be weak, so this new closure will use that.
                }
            }
        }
    }
    
    //.Create a new NSExtensionItem object that will host our items.
    //.Create a dictionary containing the key "customJavaScript" and the value of our script.
    //.Put that dictionary into another dictionary with the key NSExtensionJavaScriptFinalizeArgumentKey.
    //.Wrap the big dictionary inside an NSItemProvider object with the type identifier kUTTypePropertyList.
    //.Place that NSItemProvider into our NSExtensionItem as its attachments.
    //.Call completeRequest(returningItems:), returning our NSExtensionItem.
    
    //I realize that seems like far more effort than it ought to be, but it's really just the reverse of what we are doing inside viewDidLoad().
    
    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        // self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
        
       let item = NSExtensionItem()
        //let scripts = "document.querySelector('body').style.backgroundColor = 'black';"
        let argument: NSDictionary = ["customJavaScript": script.text ?? ""]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]

        extensionContext?.completeRequest(returningItems: [item])
    }
}
/*
 NSDictionary is a new data type, and it’s not really one you have much cause to use in Swift that often because it’s a bit of a holdover from older iOS code. Put simply, NSDictionary works like a Swift dictionary, except you don't need to declare or even know what data types it holds. One of the nasty things about NSDictionary is that you don't need to declare or even know what data types it holds.

 Yes, it's both an advantage and a disadvantage in one, which is why modern Swift dictionaries are preferred. When working with extensions, however, it's definitely an advantage because we just don't care what's in there – we just want to pull out our data.
 
 When you use loadItem(forTypeIdentifier:), your closure will be called with the data that was received from the extension along with any error that occurred. Apple could provide other data too, so what we get is a dictionary of data that contains all the information Apple wants us to have, and we put that into itemDictionary.
 
 Right now, there's nothing in that dictionary other than the data we sent from JavaScript, and that's stored in a special key called NSExtensionJavaScriptPreprocessingResultsKey. So, we pull that value out from the dictionary, and put it into a value called javaScriptValues.
 */
