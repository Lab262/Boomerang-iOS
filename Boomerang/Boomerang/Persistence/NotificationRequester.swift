//
//  NotificationRequester.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 25/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class NotificationRequester: NSObject {
    
    static func readNotification(notification: NotificationModel, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
    
        var queryParams = [String: Any]()
        queryParams[ObjectKeys.objectId] = notification.objectId
//        var colunmsUpdated = [String: Any]()
//        
//        colunmsUpdated[NotificationModelKeys.hasBeenSeen] = status
//        
//        ParseRequest.updateObject(className: NotificationModel.parseClassName().parseClassName, queryParams: queryParams, colunmsUpdated: colunmsUpdated) { (success, msg) in
//            completionHandler(success, msg)
//        }

    }
    
    static func getNotifications(profile: Profile, notificationDownloaded: [NotificationModel], pagination: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, [NotificationModel]?) -> ()) {
        
        var notifications: [NotificationModel] = [NotificationModel]()
        var objectIds: [String] = [String]()
            
        notificationDownloaded.forEach {
            objectIds.append($0.objectId!)
        }
        
        let query = PFQuery(className: "Notification")
        query.addDescendingOrder(ObjectKeys.createdAt)
        query.whereKey("receiver", equalTo: profile)
        query.includeKey("sender")
        query.includeKey("post")
        query.includeKey("scheme")
        query.selectKeys(["sender", "post", "hasBeenSeen", "notificationDescription", "scheme"])
        query.whereKey("objectId", notContainedIn: objectIds)
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                
                if let objects = objects {
                    for obj in objects {
                        let notification = obj as? NotificationModel
                        notification?.receiver = profile
                        notification?.post?.setupEnums()
                        notification?.scheme?.post = notification?.post
                        if notification?.post?.author?.objectId == profile.objectId {
                            notification?.post?.author = profile
                            notification?.scheme?.post?.author = profile
                            notification?.scheme?.owner = profile
                            notification?.scheme?.requester = notification?.sender
                        } else {
                            notification?.post?.author = notification?.sender
                            notification?.scheme?.post?.author = notification?.sender
                            notification?.scheme?.owner = notification?.sender
                            notification?.scheme?.requester = profile
                            
                        }
                        
                        notifications.append(notification!)
                    }
                }
                completionHandler(true, "success", notifications)
            } else {
                completionHandler(false, error!.localizedDescription, nil)
            }
        }
    }
}
