//
//  PostRequest.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 19/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class PostRequest: NSObject {
    
    static func fetchPostByFollowing(following: [User], pagination: Int, skip: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, [Post]?) -> Void) {
        
        var posts: [Post] = [Post]()
 
        ParseRequest.queryContainedIn(className: "Post", key: "author", value: following, pagination: pagination, skip: skip) { (success, msg, objects) in
            
            if success {
                for obj in objects! {
                    let post = Post(object: obj)
                    post.author = findAuthorByPost(following: following, authorId: post.author!.objectId!)
                    posts.append(post)
                }
                completionHandler(true, msg, posts)
            } else {
                completionHandler(false, msg, nil)
            }
        }
    }
    
    static func getFollowingPostsCount(following: [User], completionHandler: @escaping (_ success: Bool, _ msg: String, Int?) -> Void) {
        
        ParseRequest.queryCountContainedIn(className: "Post", key: "author", value: following) { (success, msg, count) in
            
            if success {
                completionHandler(true, msg, count)
            } else {
                completionHandler(true, msg, nil)
            }
        }
        
    }
    
    static func findAuthorByPost(following: [User], authorId: String) -> User? {
        for follow in following where follow.objectId == authorId {
            return follow
        }
        return nil
    }
    
    static func getRelationsInBackground(post: Post,completionHandler: @escaping (_ success: Bool, _ msg: String) -> Void) {
        
        var notContainedKeys = [Photo]()
        
        if let relations = post.relations {
            for relation in relations where relation.isDownloadedImage {
                notContainedKeys.append(relation)
            }
        }
        
        post.getRelationsInBackgroundBy(key: "photos", keyColunm: "imageFile", isNotContained: true, notContainedKeys: notContainedKeys ) { (success, msg, objects) in
            
            if success {
                if post.relations == nil {
                    post.relations = [Photo]()
                }
                
                for object in objects! {
                    let relation = Photo(object: object)
                    post.relations?.append(relation)
                }
                completionHandler(true, "Success")
            } else {
                completionHandler(false, msg)
            }
        }
    }
    
    static func fetchInterestedOf(post: Post, selectKeys: [String]?, pagination: Int, skip: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, [Interested]?) -> Void) {
        
        var interesteds: [Interested] = [Interested]()
        
        ParseRequest.queryEqualToValueWithInclude(className: "Interested", key: "post", value: post, include: "user", selectKeys: selectKeys, pagination: pagination, skip: skip) { (success, msg, objects) in
            
            if success {
                for object in objects! {
                    let interested = Interested(object: object)
                    interested.post = post
                    interesteds.append(interested)
                }
                
                completionHandler(true, msg, interesteds)
                
            } else {
                completionHandler(false, msg, nil)
            }
        }
    }
}
