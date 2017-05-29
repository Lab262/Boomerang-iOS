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
        
        ParseRequest.queryContainedIn(className: "Post", queryType: .common, whereType: .containedIn, includes: nil, cachePolicy: .networkElseCache, params: queryParams, notContainedObjects: notContainedObjects, pagination: pagination) { (success, msg, objects) in
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
    
    static func createPost(post: Post, completionHandler: @escaping (_ success: Bool, _ msg: String) -> Void) {
    
        let post = Post()
        
//        let pictureData = UIImagePNGRepresentation((allimages?.first)!)
//        let pictureFileObject = PFFile (data:pictureData!)
//        
//        post.author = ApplicationState.sharedInstance.currentUser?.profile
//        //        post.title =  self.nameThing
//        //        post.content = self.descriptionThing
//        post.typePost = TypePost(rawValue: typeVC.rawValue)
//        post.type = post.typePost.map { $0.rawValue }
//        
//        ActivitIndicatorView.show(on: self)
//        
//        let photos = PFObject(className:"Photo")
//        photos["imageFile"] = pictureFileObject
//        
//        photos.saveInBackground(block: { (success, error) in
//            if success {
//                let relation = post.relation(forKey: "photos")
//                
//                relation.add(photos)
//                
//                post.saveInBackground(block: { (success, error) in
//                    if success {
//                        AlertUtils.showAlertError(title:"Arrmessado com sucesso", viewController:self)
//                        ActivitIndicatorView.hide(on:self)
//                        
//                        //self.view.unload()
//                    }else {
//                        AlertUtils.showAlertSuccess(title:"Ops erro!", message:"Algo deu errado.", viewController:self)
//                        ActivitIndicatorView.hide(on:self)
//                    }
//                })
//                
//                
//            }else {
//                AlertUtils.showAlertSuccess(title:"Ops erro!", message:"Algo deu errado.", viewController:self)
//                self.view.unload()
//            }
//        })
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
        
        let query = PFQuery(className: Post.parseClassName())
        query.limit = pagination
        query.includeKey("author")
       
        profiles.append(ApplicationState.sharedInstance.currentUser!.profile!)
        
        var notContainedObjectIds = [String]()
        
        if let downloadedPosts = postsDownloaded {
            downloadedPosts.forEach {
                notContainedObjectIds.append($0.objectId!)
            }
        }
        query.whereKey(ObjectKeys.objectId, notContainedIn: notContainedObjectIds)
        query.whereKey(PostKeys.author, notContainedIn: profiles)
        query.whereKey(PostKeys.isAvailable, equalTo: true)
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                for object in objects! {
                    let post = Post(object: object)
                    posts.append(post)
                }
                completionHandler(true, "success", posts)
            } else {
                completionHandler(false, (error?.localizedDescription)!, nil)
            }
        }
 
    }
    
    static func getPostsFor(profile: Profile, pagination: Int, skip: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, [Post]?) -> Void) {
        
        var posts: [Post] = [Post]()
        var queryParams = [String : Any]()
        queryParams["author"] = profile
        
        let query = PFQuery(className: Post.parseClassName())
        query.skip = skip
        query.cachePolicy = .networkElseCache
        query.limit = pagination
        query.order(byDescending: "createdAt")
        query.whereKey("author", equalTo: profile)
        
        
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                for obj in objects! {
                    let post = Post(object: obj)
                    post.author = profile
                    posts.append(post)
                }
                completionHandler(true, "", posts)
            } else {
                completionHandler(false, error.debugDescription, nil)
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
        
        post.getRelationsInBackgroundBy(key: "photos", keyColunm: "imageFile", isNotContained: true, pagination: 100, notContainedKeys: notContainedKeys, cachePolicy: .networkElseCache ) { (success, msg, objects) in
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
    
    static func updatePostIsAvailable(isAvailable: Bool, post: Post, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        let query = PFQuery(className: "Post")
        
        query.getObjectInBackground(withId: post.objectId!) { (object, error) in
            if error == nil {
                object!["isAvailable"] = isAvailable
                object?.saveInBackground(block: { (success, error) in
                    if success {
                        completionHandler(success, "success")
                    } else {
                        completionHandler(false, error!.localizedDescription)
                    }
                })
            } else {
                completionHandler(false, error!.localizedDescription)
            }
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
