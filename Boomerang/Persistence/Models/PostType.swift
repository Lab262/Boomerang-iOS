//
//  PostType.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 09/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class PostType: PFObject {
    
    @NSManaged var type: String?
}

extension PostType: PFSubclassing {
    static func parseClassName() -> String {
        return "PostType"
    }
}
