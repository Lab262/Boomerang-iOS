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
    
    @NSManaged var sender: Profile?
    @NSManaged var receiver: Profile?
    @NSManaged var post: Post?
    @NSManaged var scheme: Scheme?
    @NSManaged var notificationDescription: String?
    var hasBeenSeen: Bool?
    var createdDate: Date?
    
    override init(){
        super.init()
    }
    
}

extension NotificationModel: PFSubclassing {
    static func parseClassName() -> String {
        return "Notification"
    }
}
