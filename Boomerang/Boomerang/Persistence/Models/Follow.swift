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
    var following = [User]()
    
    override init() {
        super.init()
        
    }
    
}


extension Follow: PFSubclassing {
    static func parseClassName() -> String {
        return "Follow"
    }
}
