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
    @NSManaged var user: Profile?
    @NSManaged var isRead: Bool
    
    override init(){
        super.init()
    }
    
//    convenience init(object: PFObject) {
//        self.init()
//        
//        self.setInformationsBy(object: object)
//    }
//    
    init(message: String, user: Profile) {
        super.init()
        self.isRead = false
        self.message = message
        self.user = user
    }
    
//    func setInformationsBy(object: PFObject){
//        
//        self.objectId = object.objectId
//        self.createdDate = object.createdAt
//
//        
//        
//        if let isRead = object["isRead"] as? Bool {
//            self.isRead = isRead
//        }
//        
//        if let user = object["user"] as? Profile {
//            self.user = user
//        }
//        
//        if let message = object["message"] as? String {
//            self.message = message
//        }
//    }
}



extension Message: PFSubclassing {
    static func parseClassName() -> String {
        return "Message"
    }
}


