//
//  PostCondition.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 13/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class PostCondition: PFObject {

    @NSManaged var condition: String?
    
}

extension PostCondition: PFSubclassing {
    static func parseClassName() -> String {
        return "PostCondition"
    }
}
