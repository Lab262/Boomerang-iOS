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
    
    static func createChat(requester: Profile, owner: Profile, post: Post, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
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
    
    static func createMessageInChat(message: Message, chat: Chat, completionHandler: @escaping (_ success: Bool, _ msg: String?) -> ()) {
        
        let object = PFObject(className: message.parseClassName)
        let keys = message.allKeys
        let values = keys.map { message.value(forKey: $0) }
        
        for case let (i, value?) in values.enumerated() {
            object[keys[i]] = value
        }
        
        object.saveInBackground { (success, error) in
            if success {
                let query = PFQuery(className: "Chat")
                query.getObjectInBackground(withId: chat.objectId!) { (chat, error) in
                    if error == nil {
                        let relation = chat?.relation(forKey:"messages")
                        relation?.add(object)
                        chat?.saveInBackground(block: { (success, error) in
                            completionHandler(success, error?.localizedDescription)
                        })
                    } else {
                        completionHandler(success, error?.localizedDescription)
                    }
                }
            } else {
                completionHandler(success, error?.localizedDescription)
            }
        }
    }
    
    static func getChatOf(requester: Profile, owner: Profile, post: Post, completionHandler: @escaping (_ success: Bool, _ msg: String, _ chat: Chat?) -> ()) {
        
        var queryParams = [String : Any]()
        queryParams["requester"] = requester
        queryParams["owner"] = owner
        queryParams["post"] = post
        
        ParseRequest.queryEqualToValue(className: "Chat", queryParams: queryParams, includes: nil) { (success, msg, objects) in
            if success {
                let chat: Chat?
                
                if objects!.count > 0 {
                    chat = Chat(object: objects!.first!)
                    chat?.post = post
                    chat?.requester = requester
                    chat?.owner = owner
                    
                    completionHandler(success, msg, chat)
                } else {
                   completionHandler(false, msg, nil)
                }
                
            } else {
                completionHandler(false, msg, nil)
            }
        }
    }
    
    static func getMessagesInBackground(chat: Chat, skip: Int, pagination: Int,completionHandler: @escaping (_ success: Bool, _ msg: String, _ msgs: [Message]?) -> Void) {
        
        var messages = [Message]()
        
        chat.getRelationsInBackgroundBy(key: "messages", keyColunm: nil, isNotContained: nil, pagination: pagination, skip: skip, notContainedKeys: nil) { (success, msg, objects) in
            if success {
                for object in objects! {
                    let relation = Message(object: object)
                    messages.append(relation)
                    chat.messagesArray.append(relation)
                }
                completionHandler(success, msg, messages)
            } else {
                completionHandler(success, msg, nil)
            }
        }
    }
}
