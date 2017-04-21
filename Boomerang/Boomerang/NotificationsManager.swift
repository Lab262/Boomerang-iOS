//
//  NotificationsManager.swift
//  SocialNetwork55Lab
//
//  Created by Thiago-Bernardes on 17-04-20.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse
import UserNotifications

class NotificationsManager: NSObject {
    
    static let shared = NotificationsManager()
    
    func registerForLocalNotifications() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {(accepted, error) in
            if !accepted {
                 print("Notification access denied.")
            }
        }
        UNUserNotificationCenter.current().delegate = UIApplication.shared.delegate as! AppDelegate
        self.registerForRemoteNotifications()
    }
    
    func registerForRemoteNotifications() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        UNUserNotificationCenter.current().delegate = UIApplication.shared.delegate as! AppDelegate
        UIApplication.shared.registerForRemoteNotifications()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let installation = PFInstallation.current()
        installation?.setDeviceTokenFrom(deviceToken)
        installation?.saveInBackground() { (ok, error) in
            print(ok)
            print(error)
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        PFPush.handle(userInfo)
    }
    
}
