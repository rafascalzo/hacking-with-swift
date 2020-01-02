//
//  ActionViewController.swift
//  Extension
//
//  Created by Rafael Scalzo on 26/12/19.
//  Copyright © 2019 Rafael Scalzo. All rights reserved.
//

class SitePreference:NSObject ,NSCoding {
    
    var url: String
    var scriptText: String
    
    init(_ url: String, _ preferences: String) {
        self.url = url
        self.scriptText = preferences
    }
    
   required init?(coder: NSCoder) {
        self.url = coder.decodeObject(forKey: "url") as? String ?? ""
        self.scriptText = coder.decodeObject(forKey: "preferences") as? String ?? ""
    }
    
   func encode(with coder: NSCoder) {
        coder.encode(url, forKey: "url")
        coder.encode(scriptText, forKey: "preferences")
    }
    
    static func == (_ lhs: SitePreference, _ rhs: SitePreference) -> Bool {
        return lhs.url == rhs.url && lhs.scriptText == rhs.scriptText
    }
}

class Script:NSObject, NSCoding {
    
    var scriptName: String
    var script: String
    
    init(_ scriptName: String,_ script: String) {
        self.scriptName = scriptName
        self.script = script
    }
    
    required init?(coder: NSCoder) {
        self.scriptName = coder.decodeObject(forKey: "scriptName") as? String ?? ""
        self.script = coder.decodeObject(forKey: "script") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(scriptName, forKey: "scriptName")
        coder.encode(script, forKey: "script")
    }
    
    static func == (_ lhs: Script, _ rhs: Script) -> Bool {
        return lhs.scriptName == rhs.scriptName && lhs.script == rhs.script
    }
}

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    var actualScriptText = ""
    var preferences = [SitePreference]()
    var scripts = [Script]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         When working with the keyboard, the notifications we care about are keyboardWillHideNotification and keyboardWillChangeFrameNotification. The first will be sent when the keyboard has finished hiding, and the second will be shown when any keyboard state change happens – including showing and hiding, but also orientation, QuickType and more.

         It might sound like we don't need keyboardWillHideNotification if we have keyboardWillChangeFrameNotification, but in my testing just using keyboardWillChangeFrameNotification isn't enough to catch a hardware keyboard being connected. Now, that's an extremely rare case, but we might as well be sure!

         To register ourselves as an observer for a notification, we get a reference to the default notification center. We then use the addObserver() method, which takes four parameters: the object that should receive notifications (it's self), the method that should be called, the notification we want to receive, and the object we want to watch. We're going to pass nil to the last parameter, meaning "we don't care who sends the notification."
         */
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let saveAction = UIBarButtonItem(title: "Save script", style: .plain, target: self, action: #selector(saveScript)) 
        let doneAction = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItems = [saveAction, doneAction]
        let showCodeAction = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showCodeExamples))
        let loadScriptAction = UIBarButtonItem(title: "Load script", style: .plain, target: self, action: #selector(showCustomPreferences))
        navigationItem.leftBarButtonItems = [showCodeAction, loadScriptAction]
        
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "preferences") as? Data {
            if let savedPreferences = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [SitePreference] {
                self.preferences = savedPreferences
            }
        }
        
        if let savedScriptsData = defaults.object(forKey: "scripts") as? Data {
            if let savedScripts = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedScriptsData) as? [Script] {
                self.scripts = savedScripts
            }
        }
        
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
                    self?.script.text = ""
                    
                    for preference in self?.preferences ?? [] {
                        if preference.url == self?.pageURL {
                            self?.actualScriptText = preference.scriptText
                        }
                    }
                    //This is needed because the closure being executed as a result of loadItem(forTypeIdentifier:) could be called on any thread, and we don't want to change the UI unless we're on the main thread.
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                        self?.script.text = self?.actualScriptText
                    }
                    //You might have noticed that I haven't written [weak self] in for the async() call, and that's because it's not needed. The closure will capture the variables it needs, which includes self, but we're already inside a closure that has declared self to be weak, so this new closure will use that.
                }
            }
        }
    }
    
    func save(preference: SitePreference) {
        for alreadySaved in self.preferences {
            if preference == alreadySaved {
                return
            }
        }
        for pref in self.preferences {
            if preference.url == pref.url {
                delete(preference: pref)
            }
        }
        self.preferences.append(preference)
        if let dataToSave = try? NSKeyedArchiver.archivedData(withRootObject: preferences, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(dataToSave, forKey: "preferences")
        }
    }
    
    func save(script: Script) {
        for alreadySaved in scripts {
            if alreadySaved == script {
                return
            }
        }
        
        for savedScript in scripts {
            if script.scriptName == savedScript.scriptName {
                delete(savedScript)
            }
        }
        
        scripts.append(script)
        if let dataToSave = try? NSKeyedArchiver.archivedData(withRootObject: scripts, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(dataToSave, forKey: "scripts")
        }
    }
    
    func delete(_ script: Script) {
        scripts.removeAll { (actualScript) -> Bool in
            if script == actualScript {
                return true
            }
            return false
        }
    }
    
    func delete(preference: SitePreference) {
        
        preferences.removeAll { (actualPreference) -> Bool in
            if preference == actualPreference {
                return true
            }
            return false
        }
    }
    
    @objc func saveScript() {
        let ac = UIAlertController(title: "Choose script name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let ok = UIAlertAction(title: "Save", style: .default) { action in
            guard let tf = ac.textFields?.first else { return }
            guard tf.text != nil, tf.text != "",let text = tf.text else { return }
            guard self.script.text != nil, self.script.text != "",let script = self.script.text else { return }
            let scriptText = Script(text, script)
            self.save(script: scriptText)
            print(tf.text!)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(ok)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
    
    @objc func showCodeExamples(action: UIBarButtonItem) {
        let ac = UIAlertController(title: "Code Examples", message: nil, preferredStyle: .alert)
        let showAlert = UIAlertAction(title: "Show alert", style: .default) { _ in
            self.script.text += "alert(document.title);\n"
        }
        let changeBackground = UIAlertAction(title: "Change Background", style: .default) { _ in
            self.script.text += "document.querySelector('body').style.backgroundColor = 'red';\n"
        }
        let changeButtonsColor = UIAlertAction(title: "Change Buttons colors", style: .default) { _ in
            self.script.text += """
            Array.from(document.querySelectorAll('button')).map(function(button) {
                       button.style.backgroundColor="green";
            })\n
            """
        }
        ac.addAction(showAlert)
        ac.addAction(changeBackground)
        ac.addAction(changeButtonsColor)
        present(ac, animated: true)
    }
    
    @objc func showCustomPreferences() {
        let controller = PreferencesView(nibName: "PreferencesView", bundle: .main)
        controller.scripts = self.scripts
        controller.delegate = self
        controller.modalPresentationStyle = .formSheet
        present(controller, animated: true)
    }
    
    /*
     The adjustForKeyboard() method is complicated, but that's because it has quite a bit of work to do. First, it will receive a parameter that is of type Notification. This will include the name of the notification as well as a Dictionary containing notification-specific information called userInfo.

     When working with keyboards, the dictionary will contain a key called UIResponder.keyboardFrameEndUserInfoKey telling us the frame of the keyboard after it has finished animating. This will be of type NSValue, which in turn is of type CGRect. The CGRect struct holds both a CGPoint and a CGSize, so it can be used to describe a rectangle.

     One of the quirks of Objective-C was that arrays and dictionaries couldn't contain structures like CGRect, so Apple had a special class called NSValue that acted as a wrapper around structures so they could be put into dictionaries and arrays. That's what's happening here: we're getting an NSValue object, but we know it contains a CGRect inside so we use its cgRectValue property to read that value.

     Once we finally pull out the correct frame of the keyboard, we need to convert the rectangle to our view's co-ordinates. This is because rotation isn't factored into the frame, so if the user is in landscape we'll have the width and height flipped – using the convert() method will fix that.

     The next thing we need to do in the adjustForKeyboard() method is to adjust the contentInset and scrollIndicatorInsets of our text view. These two essentially indent the edges of our text view so that it appears to occupy less space even though its constraints are still edge to edge in the view.

     Finally, we're going to make the text view scroll so that the text entry cursor is visible. If the text view has shrunk this will now be off screen, so scrolling to find it again keeps the user experience intact.

     It's not a lot of code, but it is complicated – par for the course on this project, it seems. Anyway, here's the method:
     */
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentSize = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    /*
     As you can see, setting the inset of a text view is done using the UIEdgeInsets struct, which needs insets for all four edges. I'm using the text view's content inset for its scrollIndicatorInsets to save time.

     Note there's a check in there for UIKeyboardWillHide, and that's the workaround for hardware keyboards being connected by explicitly setting the insets to be zero.
     */
    
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
        
        let preference = SitePreference(self.pageURL, self.script.text ?? "")
        save(preference: preference)
    }
}
/*
 NSDictionary is a new data type, and it’s not really one you have much cause to use in Swift that often because it’s a bit of a holdover from older iOS code. Put simply, NSDictionary works like a Swift dictionary, except you don't need to declare or even know what data types it holds. One of the nasty things about NSDictionary is that you don't need to declare or even know what data types it holds.

 Yes, it's both an advantage and a disadvantage in one, which is why modern Swift dictionaries are preferred. When working with extensions, however, it's definitely an advantage because we just don't care what's in there – we just want to pull out our data.
 
 When you use loadItem(forTypeIdentifier:), your closure will be called with the data that was received from the extension along with any error that occurred. Apple could provide other data too, so what we get is a dictionary of data that contains all the information Apple wants us to have, and we put that into itemDictionary.
 
 Right now, there's nothing in that dictionary other than the data we sent from JavaScript, and that's stored in a special key called NSExtensionJavaScriptPreprocessingResultsKey. So, we pull that value out from the dictionary, and put it into a value called javaScriptValues.
 */
extension ActionViewController: ActionViewDelegate {
    func update(_ script: String) {
        self.script.text = script
    }
}
