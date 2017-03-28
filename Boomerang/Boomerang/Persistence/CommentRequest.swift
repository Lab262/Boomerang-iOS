//
//  CommentRequest.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 28/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class CommentRequest: NSObject {
    
    static func fetchCommentsBy(post: Post, pagination: Int, skip: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, [Comment]?) -> Void) {
        
        var comments: [Comment] = [Comment]()
        
        ParseRequest.queryEqualToValueWithInclude(className: "Comment", key: "post", value: post, include: "author", pagination: pagination, skip: skip) { (success, msg, objects) in
        
             if success {
                 for object in objects! {
                    comments.append(Comment(object: object))
                 }
                completionHandler(true, "Success", comments)
             } else {
              completionHandler(false, msg.debugDescription, nil)
            }
        }
    }
}
