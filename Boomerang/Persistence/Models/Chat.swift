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
    @NSManaged var requester: Profile?
    @NSManaged var owner: Profile?
    var messagesArray: [Message] = [Message]()
    
    var messages: PFRelation<Message> {
        return self.relation(forKey: ChatKeys.messages) as! PFRelation<Message>
    }
    
    override init(){
        super.init()
    }
    
    init(post: Post, requester: Profile, owner: Profile) {
        super.init()
        self.post = post
        self.requester = requester
        self.owner = owner
    }
}

extension Chat: PFSubclassing {
    static func parseClassName() -> String {
        return "Chat"
    }
}
