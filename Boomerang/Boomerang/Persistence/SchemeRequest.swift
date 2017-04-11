//
//  SchemeRequest.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 11/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class SchemeRequest: NSObject {
    
    static func createScheme(requester: User, owner: User, chat: Chat, post: Post, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        let scheme = PFObject(className: "Scheme")
        
        scheme["post"] = ["__type": "Pointer", "className": "Post", "objectId": post.objectId]
        scheme["requester"] = ["__type": "Pointer", "className": "_User", "objectId": requester.objectId]
        scheme["owner"] = ["__type": "Pointer", "className": "_User", "objectId": owner.objectId]
        scheme["chat"] = ["__type": "Pointer", "className": "Chat", "objectId": chat.objectId]
        
        scheme.saveInBackground { (success, error) in
            if error == nil {
                completionHandler(success, "success")
            } else {
                completionHandler(success, error!.localizedDescription)
            }
        }
    }
}
