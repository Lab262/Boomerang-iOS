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
    
    static func createMessageInChat(message: Message, chat: Chat, completionHandler: @escaping (_ success: Bool, _ msg: String?) -> ()) {
        
        message.saveInBackground { (success, error) in
            if success {
                chat.messages.add(message)
                chat.saveInBackground(block: { (success, error) in
                    completionHandler(success, error?.localizedDescription)
                })
            }
        }
    }
    
    static func getChatOf(requester: Profile, owner: Profile, post: Post, completionHandler: @escaping (_ success: Bool, _ msg: String, _ chat: Chat?) -> ()) {
        
        var queryParams = [String : [Any]]()
        queryParams[ChatKeys.requester] = [requester]
        queryParams[ChatKeys.owner] = [owner]
        queryParams[ChatKeys.post] = [post]
        
        ParseRequest.queryEqualToValueNotContainedObjects(className: Chat.parseClassName(), queryType: .common, whereTypes: [.equal], params: queryParams, cachePolicy: .networkElseCache, notContainedObjects: nil, includes: nil, pagination: 100) { (success, msg, objects) in
            
            if success {
                let chat = objects?.first as? Chat
                completionHandler(success, msg, chat)
            } else {
                completionHandler(false, msg, nil)
            }
        }
    }
    
    static func getMessagesInBackground(chat: Chat, pagination: Int,completionHandler: @escaping (_ success: Bool, _ msg: String, _ msgs: [Message]?) -> Void) {
        
        var messages = [Message]()
        var messagesIds = [String]()
        chat.messagesArray.forEach {
            messagesIds.append($0.objectId!)
        }
        
        var notContainedObjects = [String: [Any]]()
        
        if messagesIds.count > 1 {
            notContainedObjects[ObjectKeys.objectId] = messagesIds
        }
        
        chat.getRelationsInBackgroundBy(key: ChatKeys.messages, keyColunm: nil, isNotContained: nil, pagination: pagination, notContainedKeys: nil, cachePolicy: .networkElseCache, notContainedObjects: notContainedObjects) { (success, msg, objects) in
            if success {
                for object in objects! {
                    let message = object as? Message
                    messages.append(message!)
                    chat.messagesArray.append(message!)
                }
                completionHandler(success, msg, messages)
            } else {
                completionHandler(success, msg, nil)
            }
        }
    }
}
