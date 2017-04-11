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
    
    static func verifyAlreadyInterestedFor(currentUser: User, post: Post, completionHandler: @escaping (_ success: Bool, _ msg: String, _ alreadyInterested: Bool) -> ()) {
        
        var queryParams = [String : Any]()
        queryParams["user"] = currentUser
        queryParams["post"] = post
        
        ParseRequest.queryEqualToValue(className: "Interested", queryParams: queryParams, include: nil) { (success, msg, objects) in
            if success {
                if objects!.count > 0 {
                    completionHandler(true, "Success", true)
                } else {
                    completionHandler(true, msg, false)
                }
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
    
    static func getPostsFor(user: User, pagination: Int, skip: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, [Post]?) -> Void) {
        
        var posts: [Post] = [Post]()
        var queryParams = [String : Any]()
        queryParams["author"] = user
        
        ParseRequest.queryEqualToValue(className: "Post", queryParams: queryParams, include: nil) { (success, msg, objects) in
            
            if success {
                for obj in objects! {
                    let post = Post(object: obj)
                    post.author = user
                    posts.append(post)
                }
                completionHandler(true, msg, posts)
            } else {
                completionHandler(false, msg, nil)
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
        var queryParams = [String : Any]()
        queryParams["post"] = post
        
        ParseRequest.queryEqualToValue(className: "Interested", queryParams: queryParams, include: "user") { (success, msg, objects) in
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
    

    static func enterInterestedListOf(user: User, post: Post, msg: String, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        let interested = PFObject(className: "Interested")
        interested["post"] = ["__type": "Pointer", "className": "Post", "objectId": post.objectId]
        interested["user"] = ["__type": "Pointer", "className": "_User", "objectId": user.objectId]
        interested["currentMessage"] = msg
        
        interested.saveInBackground { (success, error) in
            if error == nil {
                completionHandler(success, "success")
            } else {
                completionHandler(success, error!.localizedDescription)
            }
        }
    }
    
    static func exitInterestedListOf(user: User, post: Post, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        var queryParams = [String : Any]()
        queryParams["user"] = user
        queryParams["post"] = post
        
        ParseRequest.deleteObjectFor(className: "Interested", queryParams: queryParams) { (success, msg) in
            if success {
                completionHandler(true, "success")
            } else {
                completionHandler(false, msg)
            }
        }
    }
}
