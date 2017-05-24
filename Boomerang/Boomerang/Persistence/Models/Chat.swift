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
    //@NSManaged var messages: PFRelation<Message>
    var messagesArray: [Message] = [Message]()
    
    var messages: PFRelation<Message> {
        return self.relation(forKey: ChatKeys.messages) as! PFRelation<Message>
    }
    
    override init(){
        super.init()
    }
    
    convenience init(post: Post, requester: Profile, owner: Profile) {
        self.init()
        self.post = post
        self.requester = requester
        self.owner = owner
    }
    
    convenience init(object: PFObject) {
        self.init()
        
        self.setInformationsBy(object: object)
    }
    
    func setInformationsBy(object: PFObject){
        self.objectId = object.objectId
    }
}

extension Chat: PFSubclassing {
    static func parseClassName() -> String {
        return "Chat"
    }
}
