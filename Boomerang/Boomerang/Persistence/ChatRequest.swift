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
        chat["requester"] = ["__type": "Pointer", "className": "_User", "objectId": requester.objectId]
        chat["owner"] = ["__type": "Pointer", "className": "_User", "objectId": owner.objectId]
        
        chat.saveInBackground { (success, error) in
            if error == nil {
                completionHandler(success, "success")
            } else {
                completionHandler(success, error!.localizedDescription)
            }
        }
    }
    
    static func getChatOf(requester: User, owner: User, post: Post, completionHandler: @escaping (_ success: Bool, _ msg: String, _ chat: Chat?) -> ()) {
        
        var queryParams = [String : Any]()
        queryParams["requester"] = requester
        queryParams["owner"] = owner
        queryParams["post"] = post
        
        ParseRequest.queryEqualToValue(className: "Chat", queryParams: queryParams, include: nil) { (success, msg, objects) in
            if success {
                let chat: Chat?
                if objects!.count > 0 {
                    chat = Chat(object: objects!.first!)
                    chat?.post = post
                    chat?.requester = requester
                    chat?.owner = owner
                }
                completionHandler(true, msg, chat)
            } else {
                completionHandler(false, msg, nil)
            }
        }
    }
}
