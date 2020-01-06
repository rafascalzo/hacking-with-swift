//
//  User.swift
//  AnoteApp
//
//  Created by Rafael VSM on 05/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.
//

import Foundation

class User: NSObject {
    
    static var shared = User()
    
    var user = UserDefaults.standard
    
    var hasSeenSplashKey = "hasSeenSplashKey"
    var hasSeenNotesViewKey = "hasSeenNotesViewKey"
    var hasSetupICloudKey = "hasSetupICloudKey"
    
    var userNotesKey = "userNotesKey"
    
    var hasSeenSplash: Bool {
        return user.bool(forKey: hasSeenSplashKey)
    }
    
    func updateFirstTimeAppear() {
        user.set(true, forKey: hasSeenSplashKey)
    }
    
    var hasSeenNotesView: Bool {
        return user.bool(forKey: hasSeenNotesViewKey)
    }
    
    func updateFirstTimeAppearNotesView()  {
        user.set(true, forKey: hasSeenNotesViewKey)
    }
    
    func updateICloudSetup(_ status: Bool) {
        user.set(status, forKey: hasSetupICloudKey)
    }
    
    func saveUserNotes(_ data: Data) {
        user.set(data, forKey: userNotesKey)
    }
    func getUserNotes() -> Data? {
        return user.object(forKey: userNotesKey) as? Data
    }
}
