//
//  ChatRequest.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 11/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class ChatRequest: NSObject {
    
    static func createChat(requester: User, owner: User, post: Post, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        let chat = PFObject(className: "Chat")
        chat["post"] = ["__type": "Pointer", "className": "Post", "objectId": post.objectId]
        scheme["owner"] = ["__type": "Pointer", "className": "_User", "objectId": requester.objectId]
        scheme["requester"] = ["__type": "Pointer", "className": "_User", "objectId": owned.objectId]
        
        if let chat = chat {
            scheme["chat"] = ["__type": "Pointer", "className": "Chat", "objectId": chat.objectId]
        } else {
            let newChat = Chat(className: "Chat")
            
        }
    }

}
