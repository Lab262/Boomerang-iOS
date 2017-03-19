//
//  PostRequest.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 19/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class PostRequest: NSObject {
    
    static func fetchPostByFollowing(following: [User], completionHandler: @escaping (_ success: Bool, _ msg: String, [Post]?) -> Void) {
        
        var posts: [Post] = [Post]()
        
        ParseRequest.queryContainedIn(className: "Post", key: "author", value: following) { (success, msg, objects) in
            
            if success {
                for obj in objects! {
                    let post = Post(object: obj)
                    post.author = findAuthorByPost(following: following, authorId: post.author!.objectId!)
                    posts.append(post)
                    
                    completionHandler(true, "Success", posts)
                }
            } else {
                completionHandler(false, msg.debugDescription, nil)
            }
        }
    }
    
    static func findAuthorByPost(following: [User], authorId: String) -> User? {
        for follow in following {
            if follow.objectId == authorId {
                return follow
            }
        }
        return nil
    }
}
