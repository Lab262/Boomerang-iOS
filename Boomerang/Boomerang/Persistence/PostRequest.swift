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
    
    
    static func fetchFeaturedPosts(postsDownloaded:[Post], completionHandler: @escaping (_ success: Bool, _ msg: String, [Post]?) -> Void) {
        
        var posts: [Post] = [Post]()
        var params = [String: [Any]]()
        
        if postsDownloaded.count > 1 {
            params[ObjectKeys.updatedAt] = [postsDownloaded.first!.updateDate!]
            params[ObjectKeys.objectId] = postsDownloaded
        }
        
        params[ServerKeys.include] = [PostKeys.author]
        params[ServerKeys.pagination] = [Paginations.postsFeatureds]
        
        PFCloud.callFunction(inBackground: CloudFunctions.featuredPosts, withParameters: params) { (objects, error) in
            if let _ = error {
                completionHandler(false, error!.localizedDescription, nil)
            } else {
                for object in objects! as! [PFObject] {
                    let post = Post(object: object)
                    
                    posts.append(post)
                }
                
                completionHandler(true, "success", posts)
            }
        }
    }
    
    static func fetchPostByFollowing(postsDownloaded: [Post], following: [Profile], pagination: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, [Post]?) -> Void) {
        
        var posts: [Post] = [Post]()
        let queryParams = ["author" : following]
        var notContainedObjectIds = [String]()
        
        postsDownloaded.forEach{
            notContainedObjectIds.append($0.objectId!)
        }
        
        let notContainedObjects = ["objectId": notContainedObjectIds]
        
        ParseRequest.queryContainedIn(className: "Post", queryType: .common, whereType: .containedIn, includes: nil, cachePolicy: .cacheElseNetwork, params: queryParams, notContainedObjects: notContainedObjects, pagination: pagination) { (success, msg, objects) in
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
    
    static func verifyAlreadyInterestedFor(currentProfile: Profile, post: Post, completionHandler: @escaping (_ success: Bool, _ msg: String, _ alreadyInterested: Bool) -> ()) {
        
        var queryParams = [String : Any]()
        queryParams["user"] = currentProfile
        queryParams["post"] = post
        
        ParseRequest.queryEqualToValue(className: "Interested", queryParams: queryParams, includes: nil) { (success, msg, objects) in
            if success {
                if objects!.count > 0 {
                    completionHandler(true, "Success", true)
                } else {
                    completionHandler(true, msg, false)
                }
            }
        }
    }
    
    static func getFollowingPostsCount(following: [Profile], completionHandler: @escaping (_ success: Bool, _ msg: String, Int?) -> Void) {
        ParseRequest.queryCountContainedIn(className: "Post", key: "author", value: following) { (success, msg, count) in
            if success {
                completionHandler(true, msg, count)
            } else {
                completionHandler(true, msg, nil)
            }
        }
    }
    
    static func getPostsThatNotContain(friends: [Profile], postsDownloaded: [Post]? = nil, pagination: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, _ posts: [Post]?) -> ()) {
        
        var posts: [Post] = [Post]()
        
        var profiles = friends
        
        profiles.append(ApplicationState.sharedInstance.currentUser!.profile!)
        
        var notContainedObjects = [String: [Any]]()
        
        notContainedObjects["author"] = profiles
        
        var notContainedObjectIds = [String]()
        
        if let downloadedPosts = postsDownloaded {
            downloadedPosts.forEach {
                notContainedObjectIds.append($0.objectId!)
            }
            notContainedObjects["objectId"] = notContainedObjectIds
        }
        
        ParseRequest.queryGetAllObjects(className: "Post", notContainedObjects: notContainedObjects, pagination: pagination, includes: ["author"]) { (success, msg, objects) in
            if success {
                for object in objects! {
                    let post = Post(object: object)
                    //post.author = Profile(object: object.object(forKey: "author") as! PFObject)
                    posts.append(post)
                }
                completionHandler(true, "Success", posts)
            } else {
                completionHandler(false, msg.debugDescription, nil)
            }
        }
        
        
//        ParseRequest.queryEqualToValueNotContainedObjects(className: "Post", queryType: .common, whereType: .none, params: [String: [Any]](), notContainedObjects: notContainedObjects, includes: ["author"], pagination: pagination) { (success, msg, objects) in
//            if success {
//                for object in objects! {
//                    let post = Post(object: object)
//                    post.author = Profile(object: object.object(forKey: "author") as! PFObject)
//                    posts.append(post)
//                }
//                completionHandler(true, "Success", posts)
//            } else {
//                completionHandler(false, msg.debugDescription, nil)
//            }
//        }
    }
    
    static func getPostsFor(profile: Profile, pagination: Int, skip: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, [Post]?) -> Void) {
        
        var posts: [Post] = [Post]()
        var queryParams = [String : Any]()
        queryParams["author"] = profile
        
        ParseRequest.queryEqualToValue(className: "Post", queryParams: queryParams, includes: nil) { (success, msg, objects) in
            if success {
                for obj in objects! {
                    let post = Post(object: obj)
                    post.author = profile
                    posts.append(post)
                }
                completionHandler(true, msg, posts)
            } else {
                completionHandler(false, msg, nil)
            }
        }
    }
    
    static func findAuthorByPost(following: [Profile], authorId: String) -> Profile? {
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
        
        ParseRequest.queryEqualToValue(className: "Interested", queryParams: queryParams, includes: ["user"], selectKeys: nil, pagination: pagination, skip: skip) { (success, msg, objects) in
            
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
    
    static func exitInterestedListOf(profile: Profile, post: Post, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        var queryParams = [String : Any]()
        queryParams["user"] = profile
        queryParams["post"] = post
        
        ParseRequest.updateForIsDeletedObjectBy(className: "Interested", queryParams: queryParams) { (success, msg) in
            completionHandler(success, msg)
        }
    }
    
    static func getAllTypes (completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        var allTypes = [PostType]()
        
        ParseRequest.queryGetAllObjects(className: "PostType") { (success, msg, objects) in
            if success {
                objects!.forEach {
                    let type = PostType(object: $0)
                    allTypes.append(type)
                }
                ApplicationState.sharedInstance.postTypes = allTypes
            }
            completionHandler(success, msg)
        }
    }
    
    static func getAllConditions (completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        var allConditions = [PostCondition]()
        
        ParseRequest.queryGetAllObjects(className: "PostCondition") { (success, msg, objects) in
            if success {
                objects!.forEach {
                    let condition = PostCondition(object: $0)
                    allConditions.append(condition)
                }
                ApplicationState.sharedInstance.postConditions = allConditions
            }
            completionHandler(success, msg)
        }
    }
}
