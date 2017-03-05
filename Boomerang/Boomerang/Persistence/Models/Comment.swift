//
//  Comment.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class Comment: PFObject {
    
    @NSManaged var post: Post?
    @NSManaged var content: String?
    @NSManaged var author: User?
    
}

extension Comment: PFSubclassing {
    static func parseClassName() -> String {
        return "Comment"
    }
}
