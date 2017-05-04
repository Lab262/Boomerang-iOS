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
    
    var followers = [Profile]()
    @NSManaged var since: Date?
    @NSManaged var from: Profile?
    @NSManaged var to: Profile?
    var toFollow: [Profile]?
    
    override init(){
        super.init()
    }
    
    convenience init(from: Profile, to: Profile) {
        self.init()
        self.from = from
        self.to = to
        self.since = Date()
    }
    
    convenience init(object: PFUser) {
        self.init()
        setInformationsUserByPFObject(object: object)
    }
    
    
    func setInformationsUserByPFObject(object: PFObject){
        
        self.objectId = object.objectId
        
        if let follow = object["to"] as? Profile {
            toFollow?.append(follow)
        }
    }
    
}


extension Follow: PFSubclassing {
    static func parseClassName() -> String {
        return "Follow"
    }
}
