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
        query.whereKey("receiver", equalTo: profile)
        query.includeKey("sender")
        query.includeKey("post")
        query.selectKeys(["sender", "post", "hasBeenSeen", "notificationDescription"])
        query.whereKey("objectId", notContainedIn: objectIds)
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                for obj in objects! {
                    let notification = NotificationModel(object: obj)
                    notification.receiver = profile
                    notification.post?.author = profile
                    notifications.append(notification)
                }
                completionHandler(true, "success", notifications)
            } else {
                completionHandler(false, error!.localizedDescription, nil)
            }
        }
    }
}
