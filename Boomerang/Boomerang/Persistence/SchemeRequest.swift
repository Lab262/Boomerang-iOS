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
    
    static func createScheme(requester: Profile, owner: Profile, chat: Chat, post: Post, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
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
    
    static func getSchemesForUser(owner: Profile, pagination: Int, skip: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, _ schemes: [Scheme]?) -> ()) {
        
        var schemes = [Scheme]()
        var queryParams = [String : Any]()
        queryParams["owner"] = owner
        
        ParseRequest.queryEqualToValue(className: "Scheme", queryParams: queryParams, includes: ["requester", "post"], selectKeys: nil, pagination: pagination, skip: skip) { (success, msg, objects) in
            
            if success {
                for obj in objects! {
                    let scheme = Scheme(object: obj)
                    scheme.owner = owner
                    scheme.post?.author = owner
                    schemes.append(scheme)
                }
                completionHandler(success, msg, schemes)
            } else {
                completionHandler(success, msg, nil)
            }
        }
    }
}
