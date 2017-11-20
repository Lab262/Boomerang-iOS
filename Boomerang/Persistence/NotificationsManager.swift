//
//  NotificationsManager.swift
//  OhMyBox
//
//  Created by Thiago-Bernardes on 17-04-26.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import UserNotifications
import Parse

//MARK: Remote NotificationsManager
class NotificationsManager: NSObject {
    
    static func registerForNotifications() {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge]) {(accepted, error) in
                if !accepted {
                    print("Notification access denied.")
                } else {
                    UNUserNotificationCenter.current().delegate = UIApplication.shared.delegate as! AppDelegate
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    
    
}

//MARK: - Local notifications manger IOS 10.0
extension NotificationsManager {
    @available(iOS 10.0, *)
    static func deleteLocalNotification(_ id : String){
        
        //DEBUG WHAT ARE THE SCHEDULED NOTIFICATIONS
        //        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications: [UNNotification]) in
        //            // print(notifications)
        //        }
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    @available(iOS 10.0, *)
    static func scheduleLocalNotification(at date: Date, withTitle: String, andBody: String, identifier: String? = "identifier", userInfo: [String: Any]? = [String:Any](), categoryId: String? = "category" ) {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = withTitle
        content.body = andBody
        content.sound = UNNotificationSound.default()
        content.userInfo = userInfo!
        content.categoryIdentifier = categoryId!
        
        let request = UNNotificationRequest(identifier: identifier!, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) {(error) in
            if error != nil {
                print("Uh oh! We had an error: \(String(describing: error))")
            } else {
            }
        }
    }
}

//MARK: - Token handle
extension AppDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let installation = PFInstallation.current()
        installation?.setDeviceTokenFrom(deviceToken)
        installation?.saveInBackground() { (ok, error) in
            print(ok)
        }
        
    }
    
}

//MARK: IOS 9.0 delegates
extension AppDelegate {
    //    @available
    //    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
    //        UIApplication.shared.registerForRemoteNotifications()
    //    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    //IOS 9.0
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        NotificationsManager.handleNotificationByApplicationState(application: application, userInfo: userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    //IOS 9.0
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        NotificationsManager.handleNotificationByApplicationState(application: application, userInfo: userInfo)
    }
    
}

//MARK: IOS 10.0 delegates
@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        var notificationCategory = notification.request.content.categoryIdentifier
        if notificationCategory == "" {
            if let notificationCategoryFirebase = notification.request.content.userInfo["gcm.notification.categoryIdentifier"] as? String {
                notificationCategory = notificationCategoryFirebase
            }
        }
        let application = UIApplication.shared
        NotificationsManager.handleNotificationByApplicationState(application: application, userInfo:  notification.request.content.userInfo)
        
        // completionHandler([.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let application = UIApplication.shared
        NotificationsManager.handleNotificationByApplicationState(application: application, userInfo: response.notification.request.content.userInfo)
        NotificationsManager.handleNotificationTap(userInfo: response.notification.request.content.userInfo)
        
        completionHandler()
    }
}

//MARK: Handle Notifications
extension NotificationsManager {
    
    static func handleNotificationByApplicationState(application: UIApplication,userInfo: [AnyHashable: Any]) {
        NotificationsManager.handleNotificationGeneric(userInfo: userInfo)
        if ( application.applicationState == .inactive || application.applicationState == .background  )
        {
            NotificationsManager.handleNotificationBackground(userInfo: userInfo)
            PFPush.handle(userInfo)
        } else {
            NotificationsManager.handleNotificationForeground(userInfo: userInfo)
        }
    }
    
    static func handleNotificationForeground(userInfo: [AnyHashable: Any]) {
        
        if #available(iOS 10.0, *) {
        } else { //ios < 10.0
        }
    }
    
    static func handleNotificationBackground(userInfo: [AnyHashable: Any]) {
    }
    
    static func handleNotificationGeneric(userInfo: [AnyHashable: Any]) {
        
        
        
    }
    
    static func handleNotificationTap(userInfo: [AnyHashable: Any]) {
        if let aps = userInfo["aps"] as? [String: Any],
            let category = aps["category"] as? String {
            
            var thingPostId = ""
            if let postObject = userInfo["postId"] as? [String: Any],
                let postId = postObject["objectId"] as? String {
                thingPostId = postId
            }
            
            var schemeId = ""
            if let schemeObject = userInfo["schemeId"] as? [String: Any],
                let id = schemeObject["objectId"] as? String {
                schemeId = id
            }
            print(category)
            print(schemeId)
            print(thingPostId)
            UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber > 0 ? UIApplication.shared.applicationIconBadgeNumber - 1 : 0
            if let badge = PFInstallation.current()?.badge {
                PFInstallation.current()?.badge = badge > 0 ? badge - 1 : 0
                PFInstallation.current()?.saveEventually()
            }
           
            switch category {
            case "waitingList", "postUpdate", "recommendation":
                if TabBarController.mainTabBarController != nil {
                    let sender = UIButton()
                    sender.tag = 0
                    TabBarController.mainTabBarController.selectButton(sender)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeys.showDetailThingsForPost), object: nil, userInfo: ["postObject": thingPostId])
                }
                break
            case "scheme":
                if TabBarController.mainTabBarController != nil {
                    let sender = UIButton()
                    sender.tag = 3
                    TabBarController.mainTabBarController.selectButton(sender)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeys.showSchemeDetailForScheme), object: nil, userInfo: ["schemeObject": schemeId])
                }
                break

                break
            default:
                break
            }
        }
        //your wait list -> Open your thing detail -> Category And ThingPost Id
        //commented your post -> Openy  our thing edtail -> Category And ThingPost ID
        
        //accepted scheme -> open scheme detail -> Category -> Scheme id
        //finished schema -> open scheme detail -> Category -> Scheme id
        
        //recommended a post -> Open thing edtail -> Category And ThingPostID
        
    }
    
    
}

