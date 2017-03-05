//
//  Post.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class Post: PFObject {
    
    @NSManaged var user: User?
    @NSManaged var title: String?
    @NSManaged var content: String?
    @NSManaged var thing: Thing?
}

extension Post: PFSubclassing {
    static func parseClassName() -> String {
        return "Post"
    }
}
