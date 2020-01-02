//
//  ViewController.swift
//  Project_21_Local_Notifications
//
//  Created by Rafael Scalzo on 02/01/20.
//  Copyright © 2020 Rafael Scalzo. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        // Do any additional setup after loading the view.
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
        
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        let content = UNMutableNotificationContent()
        content.title = "Wake up dude!"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["CustomData":"fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
               dateComponents.hour = 7
               dateComponents.minute = 33
        print(dateComponents)
        print(Date())
               
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request) { (error) in
            if let error = error {
                print("deu erro aqui \(error.localizedDescription)")
            }
        }
    }

}

