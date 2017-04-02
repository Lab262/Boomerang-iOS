//
//  Interested.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 01/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class Interested: PFObject {

    @NSManaged var user: User?
    @NSManaged var post: Post?
    @NSManaged var currentMessage: String?
    
    convenience init(object: PFObject) {
        self.init()
        
        self.setInformationsUserByPFUser(object: object)
    }
    
    func setInformationsUserByPFUser(object: PFObject){
        
        self.objectId = object.objectId
        
        if let user = object["user"] as? User {
            self.user = User(user: user)
        }
        
        if let currentMessage = object["currentMessage"] as? String {
            self.currentMessage = currentMessage
        }
    }
}

extension Interested: PFSubclassing {
    static func parseClassName() -> String {
        return "Interested"
    }
}
