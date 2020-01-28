//
//  ViewController.swift
//  Project_28_FaceID_TouchID_Keychain
//
//  Created by Rafael VSM on 27/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var secret: UITextView!
    
    // We're already using NotificationCenter to watch for the keyboard appearing and disappearing, and we can watch for another notification that will tell us when the application will stop being active – i.e., when our app has been backgrounded or the user has switched to multitasking mode. This notification is called UIApplication.willResignActiveNotification, and you should make us an observer for it in viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nothing to see here"
        // Do any additional setup after loading the view.
        let notification = NotificationCenter.default
        
        notification.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
        // Keyboard notification
        notification.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notification.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction func authenticateTapped(_ sender: Any) {
        unlockSecretMessage()
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"
        
        if let text = KeychainWrapper.standard.string(forKey: "SecretMessage") {
            secret.text = text
        }
        // or
       // secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    //I slipped a new method in there: resignFirstResponder(). This is used to tell a view that has input focus that it should give up that focus. Or, in Plain English, to tell our text view that we're finished editing it, so the keyboard can be hidden. This is important because having a keyboard present might arouse suspicion – as if our rather obvious navigation bar title hadn't done enough already…
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
}

