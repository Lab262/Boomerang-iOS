//
//  NotificationModel.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 25/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class NotificationModel: PFObject {
    
    @NSManaged var sender: User?
    @NSManaged var receiver: User?
    @NSManaged var post: Post?
    @NSManaged var notificationDescription: String?
    var hasBeenSeen: Bool?
    var createdDate: Date?
    
    override init(){
        super.init()
    }
    
    convenience init(object: PFObject) {
        self.init()
        
        setInformationsUserByPFObject(object: object)
    }
    
    
    func setInformationsUserByPFObject(object: PFObject){
        
        self.objectId = object.objectId
        self.createdDate = object.createdAt
        
        if let sender = object["sender"] as? User {
            self.sender = sender
        }
        
        if let receiver = object["receiver"] as? User {
            self.receiver = receiver
        }
        
        if let post = object["post"] as? Post {
            self.post = post
        }
        
        if let notificationDescription = object["notificationDescription"] as? String {
            self.notificationDescription = notificationDescription
        }
        
        if let hasBeenSeen = object["hasBeenSeen"] as? Bool {
            self.hasBeenSeen = hasBeenSeen
        }
    }
}

extension NotificationModel: PFSubclassing {
    static func parseClassName() -> String {
        return "Notification"
    }
}
