//
//  ViewController.swift
//  Project_21_Local_Notifications
//
//  Created by Rafael Scalzo on 02/01/20.
//  Copyright © 2020 Rafael Scalzo. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsView: UIViewController , UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        // Do any additional setup after loading the view.
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
        let remindMeLater = UNNotificationAction(identifier: "later", title: "Remind-me later", options: .destructive)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remindMeLater], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,.badge,.sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        let content = UNMutableNotificationContent()
        content.title = "Wake up dude!"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["CustomData":"fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        
//        var dateComponents = DateComponents()
//               dateComponents.hour = 15
//               dateComponents.minute = 25
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
         
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request) { (error) in
            if let error = error {
                print("deu erro aqui \(error.localizedDescription)")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["CustomData"] as? String {
            print("custom data received! \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("Default identifier")
            case "show":
                let ac = UIAlertController(title: "Cheers", message: "You have earned $ 1.000.000,00 from your last transaction", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                present(ac, animated: true)
                print("Show more information")
                
            case "later":
                print("remind-me later")
                scheduleLocal()
            default:
                break
            }
        }
        // you must call the completion handler when you're done
        completionHandler()
    }
}

