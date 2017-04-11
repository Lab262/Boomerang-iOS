//
//  Chat.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 10/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class Chat: PFObject {
    @NSManaged var post: Post?
    @NSManaged var requester: User?
    @NSManaged var owner: User?
    @NSManaged var messages: [Message]?
}

extension Chat: PFSubclassing {
    static func parseClassName() -> String {
        return "Chat"
    }
}
