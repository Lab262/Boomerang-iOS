//
//  Message.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 10/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class Message: PFObject {
    @NSManaged var user: User?
    @NSManaged var message: String?
}

extension Message: PFSubclassing {
    static func parseClassName() -> String {
        return "Message"
    }
}


