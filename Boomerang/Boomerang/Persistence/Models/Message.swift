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
    @NSManaged var user: User?
    @NSManaged var message: String?
    
    override init(){
        super.init()
    }
    
    convenience init(object: PFObject) {
        self.init()
        
        self.setInformationsBy(object: object)
    }
    
    func setInformationsBy(object: PFObject){
        
        self.objectId = object.objectId
        
        if let user = object["user"] as? User {
            self.user = User(user: user)
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


