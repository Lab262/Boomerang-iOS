//
//  Recommended.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 15/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class Recommended: PFObject {
    
    @NSManaged var sender: Profile?
    @NSManaged var post: Post?
    @NSManaged var receiver: Profile?
    
    override init(){
        super.init()
    }
    
    init(sender: Profile?, post: Post?, receiver: Profile?) {
        super.init()
        self.sender = sender
        self.post = post
        self.receiver = receiver
    }    
}

extension Recommended: PFSubclassing {
    static func parseClassName() -> String {
        return "Recommended"
    }
}
