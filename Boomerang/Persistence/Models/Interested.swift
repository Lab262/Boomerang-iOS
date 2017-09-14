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

    @NSManaged var user: Profile?
    @NSManaged var post: Post?
    @NSManaged var currentMessage: String?
    
    
    override init(){
        super.init()
    }
    
     init(user: Profile?, post: Post?, currentMessage: String?) {
        super.init()
        self.user = user
        self.post = post
        self.currentMessage = currentMessage
    }
}

extension Interested: PFSubclassing {
    static func parseClassName() -> String {
        return "Interested"
    }
}
