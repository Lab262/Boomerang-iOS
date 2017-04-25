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
    
    static func getNotifications(by user: User, pagination: Int, skip: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, [NotificationModel]?) -> ()) {
        
        var notifications: [NotificationModel] = [NotificationModel]()
        
        let includes = ["sender", "post"]
        let selectKeys = ["sender", "post", "hasBeenSeen", "notificationDescription"]
        var queryParams = [String : Any]()
        queryParams["receiver"] = user
        
        
        ParseRequest.queryEqualToValue(className: "Notification", queryParams: queryParams, includes: includes, selectKeys: selectKeys, pagination: pagination, skip: skip) { (success, msg, objects) in
            
            if success {
                for obj in objects! {
                    let notification = NotificationModel(object: obj)
                    notification.receiver = user
                    notification.post?.author = user
                    notifications.append(notification)
                }
                completionHandler(success, msg, notifications)
            } else {
                completionHandler(success, msg, nil)
            }
        }
        
    }
}
