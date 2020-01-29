//
//  ViewController.swift
//  Project_28_FaceID_TouchID_Keychain
//
//  Created by Rafael VSM on 27/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.
//

import UIKit


/*
 Touch ID and Face ID are part of the Local Authentication framework, and our code needs to do three things:

 Check whether the device is capable of supporting biometric authentication – that the hardware is available and is configured by the user.
 If so, request that the biometry system begin a check now, giving it a string containing the reason why we're asking. For Touch ID the string is written in code; for Face ID the string is written into our Info.plist file.
 If we get success back from the authentication request it means this is the device's owner so we can unlock the app, otherwise we show a failure message.
 
 There is one important new piece of syntax in there that we haven’t used before, which is &error. The LocalAuthentication framework uses the Objective-C approach to reporting errors back to us, which is where the NSError type comes from – where Swift likes to have an enum that conforms to the Error protocol, Objective-C had a dedicated NSError type for handling errors.

 Here, though, we want LocalAuthentication to tell us what went wrong, and it can’t do that by returning a value from the canEvaluatePolicy() method – that already returns a Boolean telling us whether biometric authentication is available or not. So, instead what we use is the Objective-C equivalent of Swift’s inout parameters: we pass an empty NSError variable into our call to canEvaluatePolicy(), and if an error occurs that error will get filled with a real NSError instance telling us what went wrong.

 Objective-C’s equivalent to inout is what’s called a pointer, so named because it effectively points to a place in memory where something exists rather us passing around the actual value instead. If we had passed error into the method, it would mean “here’s the error you should use.” By passing in &error – Objective-C’s equivalent of inout – it means “if you hit an error, here’s the place in memory where you should store that error so I can read it.”

 I hope you can now see this is another example of why Swift was such a leap forward compared to Objective-C – having to pass around pointers to things wasn’t terribly pleasant!

 Apart from that, there are a couple of reminders: we need [weak self] inside the first closure but not the second because it's already weak by that point. You also need to use self?. inside the closure to make capturing clear. Finally, you must provide a reason why you want Touch ID/Face ID to be used, so you might want to replace mine ("Identify yourself!") with something a little more descriptive.

 You can see the “Identify yourself!” string in our code, which will be shown to Touch ID users. Face ID is handled slightly differently – open Info.plist, then add a new key called “Privacy - Face ID Usage Description”. This should contain similar text to what you use with Touch ID, so give it the value “Identify yourself!”.

 That's enough to get basic biometric authentication working, but there are error cases you need to catch. For example, you’ll hit problems if the device does not have biometric capability or it isn’t configured. Similarly, you’ll get an error if the user failed authentication, which might be because their fingerprint or face wasn't scanning for whatever reason, but also if the system has to cancel scanning for some reason.
 */
import  LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet var secret: UITextView!
    
    // We're already using NotificationCenter to watch for the keyboard appearing and disappearing, and we can watch for another notification that will tell us when the application will stop being active – i.e., when our app has been backgrounded or the user has switched to multitasking mode. This notification is called UIApplication.willResignActiveNotification, and you should make us an observer for it in viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDoneTapped))
        // Do any additional setup after loading the view.
        let notification = NotificationCenter.default
        
        notification.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
        // Keyboard notification
        notification.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notification.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: "firstTimeKey") {
            let ac = UIAlertController(title: "Add a security password", message: nil, preferredStyle: .alert)
            ac.addTextField()
            let ok = UIAlertAction(title: "save", style: .default) { [weak self] _ in
                guard let textField = ac.textFields?.first else { return }
                guard textField.text != nil, textField.text != "", let password = textField.text else {
                    self?.present(ac, animated: true)
                    return }
                KeychainWrapper.standard.set(password, forKey: "passwordKey")
                userDefaults.set(true, forKey: "firstTimeKey")
            }
            ac.addAction(ok)
            present(ac, animated: true)
        }
    }
    
    @IBOutlet var authenticateButton: UIButton!
    
    @objc func handleDoneTapped() {
        secret.resignFirstResponder()
        secret.isHidden = true
        authenticateButton.isHidden = false
    }
    
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        // Using an ampersand before a parameter being passed into a function works like Swift's inout parameters.
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
//            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            self.present(ac, animated: true)
            let ac = UIAlertController(title: "Password", message: nil, preferredStyle: .alert)
            ac.addTextField()
            let ok = UIAlertAction(title: "ok", style: .default) { [weak self] _ in
                guard let textField = ac.textFields?.first else { return }
                guard textField.text != nil, textField.text != "", let password = textField.text else {
                    self?.present(ac, animated: true)
                    return }
                let savedPassword = KeychainWrapper.standard.string(forKey: "passwordKey") ?? ""
                if password == savedPassword {
                    self?.unlockSecretMessage()
                } else {
                    let wrong = UIAlertController(title: "Password incorrect!", message: nil, preferredStyle: .alert)
                    wrong.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                        self?.present(ac, animated: true)
                    }))
                    self?.present(wrong, animated: true)
                }
            }
            ac.addAction(ok)
            present(ac, animated: true)
        }
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
        authenticateButton.isHidden = false
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

