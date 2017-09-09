//
//  Like.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 27/08/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class Like: PFObject {
    
    @NSManaged var profile: Profile?
    @NSManaged var post: Post?

    override init(){
        super.init()
    }
}


extension Like: PFSubclassing {
    static func parseClassName() -> String {
        return "Like"
    }
}
