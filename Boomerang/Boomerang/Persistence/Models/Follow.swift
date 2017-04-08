//
//  Follow.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 06/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class Follow: PFObject {
    
    var followers = [User]()
    @NSManaged var to: [User]
    
    override init(){
        super.init()
    }
    
    convenience init(object: PFUser) {
        self.init()
        
        setInformationsUserByPFObject(object: object)
    }
    
    
    func setInformationsUserByPFObject(object: PFObject){
        
        self.objectId = object.objectId
        
        if let follow = object["to"] as? User {
            to.append(follow)
        }
    }
    
}


extension Follow: PFSubclassing {
    static func parseClassName() -> String {
        return "Follow"
    }
}
