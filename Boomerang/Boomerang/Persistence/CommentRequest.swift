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
    
    static func getCommentsCount(by post: Post, completionHandler: @escaping (_ success: Bool, _ msg: String, Int?) -> Void) {
        
        ParseRequest.queryCountContainedIn(className: "Comment", key: "post", value: [post]) { (success, msg, count) in
            
            if success {
                completionHandler(true, msg, count)
            } else {
                completionHandler(true, msg, nil)
            }
        }
    }
    

    
    static func fetchCommentsBy(post: Post, commentsObject: [Comment], pagination: Int,  completionHandler: @escaping (_ success: Bool, _ msg: String, [Comment]?) -> Void) {
        
        var comments: [Comment] = [Comment]()
        var queryParams = [String : Any]()
        queryParams["post"] = post
        
        var objectIds = [String]()
        
        commentsObject.forEach {
           objectIds.append($0.objectId!)
        }
        
        ParseRequest.queryEqualToValueNotContained(className: "Comment", queryParams: queryParams, notContainedIds: objectIds, includes: ["author"], selectKeys: nil, pagination: pagination) { (success, msg, objects) in
            
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
    
    static func saveComment(comment: Comment, completionHandler: @escaping (_ success: Bool, _ msg: String) -> Void) {
        
        let newComment = PFObject(className: "Comment")
        newComment["post"] = PFObject(withoutDataWithClassName: "Post", objectId: comment.post?.objectId)
        newComment["content"] = comment.content
        newComment["author"] = PFObject(withoutDataWithClassName: "_User", objectId: comment.author?.objectId)
        
        newComment.saveInBackground { (success, error) in
            if success {
                completionHandler(true, "success")
            } else {
                completionHandler(false, error.debugDescription)
                
            }
        }
    }
}
