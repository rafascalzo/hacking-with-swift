//
//  AppDelegate.swift
//  Project2
//
//  Created by rafaelviewcontroller on 10/3/19.
//  Copyright © 2019 rafaelviewcontroller. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: MainViewController())
        window?.makeKeyAndVisible()
        registerLocal()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (sucess, error) in
            if sucess {
                NSLog("%@", "User permission granted")
                self.schedule()
            } else {
                NSLog("%@", "User permission not granted")
            }
        }
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let playNow = UNNotificationAction(identifier: "playNow", title: "Let's go!", options: [.foreground])
        let remindMeLater = UNNotificationAction(identifier: "later", title: "Remind-me later", options: .destructive)
        let category = UNNotificationCategory(identifier: "playAlarm", actions: [playNow, remindMeLater], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    func schedule() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = "Project 2 are waiting for you!"
        content.body = "Let's go play out!"
        content.categoryIdentifier = "playAlarm"
        content.userInfo = ["customData":7]
        
        var date = DateComponents()
        date.hour = 1
        date.minute = 2
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("test")
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? Int {
            print(customData)
//            switch response.actionIdentifier {
//            case UNNotificationDefaultActionIdentifier:
//                schedule()
//            case "playNow":
//                print("lets go!")
//                schedule()
//            case "later":
//                print("later")
//                schedule()
//            default:
//                schedule()
//            }
        }
        
        completionHandler()
    }
}

