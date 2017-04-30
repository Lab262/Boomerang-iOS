//
//  Message.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 10/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class Message: PFObject {
    
    @NSManaged var message: String?
    @NSManaged var user: User?
    var isRead: Bool?
    var createdDate: Date?
    
    override init(){
        super.init()
    }
    
    convenience init(object: PFObject) {
        self.init()
        
        self.setInformationsBy(object: object)
    }
    
    convenience init(message: String, user: User) {
        self.init()
        self.isRead = false
        self.message = message
        self.user = user
    }
    
    func setInformationsBy(object: PFObject){
        
        self.objectId = object.objectId
        self.createdDate = object.createdAt

        
        
        if let isRead = object["isRead"] as? Bool {
            self.isRead = isRead
        }
        
        if let user = object["user"] as? User {
            self.user = user
        }
        
        if let message = object["message"] as? String {
            self.message = message
        }
    }
}



extension Message: PFSubclassing {
    static func parseClassName() -> String {
        return "Message"
    }
}


