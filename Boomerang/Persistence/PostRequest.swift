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
    
    let userDefaults = UserDefaults.standard
    
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
                
                if let objects = objects {
                    for object in objects as! [PFObject] {
                        let post = object as? Post
                        post?.setupEnums()
                        posts.append(post!)
                    }
                }                
                completionHandler(true, "success", posts)
            }
        }
    }
    
    static func isLikedPost(post: Post, completionHandler: @escaping (_ success: Bool, _ msg: String, _ alreadyLiked: Bool) -> ()) {
        
        var queryParams = [String : String]()
        
        queryParams["profileId"] = User.current()!.profile!.objectId
        
        queryParams["postId"] = post.objectId
        
        ParseRequest.queryEqualToValue(className: Like.parseClassName(), queryParams: queryParams, includes: nil) { (success, msg, objects) in
            if success {
                if let objects = objects {
                    if objects.count > 0 {
                        completionHandler(true, "Success", true)
                    } else {
                        completionHandler(true, "no liked", false)
                    }
                }
            } else {
                completionHandler(success, msg, false)
            }
        }
    }
    
    static func likePost(post: Post, completionHandler: @escaping (_ success: Bool, _ msg: String) -> Void) {
    
        var params = [String: String]()
        
        params["postId"] = post.objectId
        params["profileId"] = User.current()!.profile!.objectId
                
        PFCloud.callFunction(inBackground: CloudFunctions.likePost, withParameters: params) { (objects, error) in
            if let _ = error {
                completionHandler(false, error!.localizedDescription)
            } else {
                completionHandler(true, "success")
            }
        }
    }
    
    static func fetchPostByFollowing(postsDownloaded: [Post], following: [Profile], pagination: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, [Post]?) -> Void) {
        
        var posts: [Post] = [Post]()
        let queryParams = [PostKeys.author: following]
        var notContainedObjectIds = [String]()
        
        postsDownloaded.forEach{
            notContainedObjectIds.append($0.objectId!)
        }
        
        let notContainedObjects = [ObjectKeys.objectId: notContainedObjectIds]
        
        ParseRequest.queryContainedIn(className: Post.parseClassName(), queryType: .common, whereType: .containedIn, includes: nil, cachePolicy: .networkElseCache, params: queryParams, notContainedObjects: notContainedObjects, pagination: pagination) { (success, msg, objects) in
            if success {
                
                if let objects = objects {
                    for obj in objects {
                        let post = obj as? Post
                        post?.setupEnums()
                        post?.author = findAuthorByPost(following: following, authorId: post!.author!.objectId!)
                        posts.append(post!)
                    }
                    completionHandler(true, msg, posts)
                }
                
            } else {
                completionHandler(false, msg, nil)
            }
        }
    }
    
    static func createPost(post: Post, completionHandler: @escaping (_ success: Bool, _ msg: String) -> Void) {
    
//        let post = Post()
//        
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
        queryParams[InterestedKeys.user] = currentProfile
        queryParams[InterestedKeys.post] = post
        
        ParseRequest.queryEqualToValue(className: Interested.parseClassName(), queryParams: queryParams, includes: nil) { (success, msg, objects) in
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
        ParseRequest.queryCountContainedIn(className: Post.parseClassName(), key: PostKeys.author, value: following) { (success, msg, count) in
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
        query.order(byDescending: ObjectKeys.createdAt)
        query.includeKey(PostKeys.author)
       
        profiles.append(User.current()!.profile!)
        
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
                if let objects = objects {
                    for object in objects {
                        let post = object as? Post
                        post?.setupEnums()
                        posts.append(post!)
                    }
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
        queryParams[PostKeys.author] = profile
        
        let query = PFQuery(className: Post.parseClassName())
        query.skip = skip
        query.cachePolicy = .networkElseCache
        query.limit = pagination
        query.order(byDescending: ObjectKeys.createdAt)
        query.whereKey(PostKeys.author, equalTo: profile)
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                if let objects = objects {
                    for obj in objects {
                        let post = obj as? Post
                        post?.setupEnums()
                        post?.author = profile
                        posts.append(post!)
                    }
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
                if let objects = objects {
                    for object in objects {
                        let relation = object as? Photo
                        post.relations?.append(relation!)
                    }
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
        queryParams[InterestedKeys.post] = post
        
        ParseRequest.queryEqualToValue(className: Interested.parseClassName(), queryParams: queryParams, includes: [InterestedKeys.user], selectKeys: nil, pagination: pagination, skip: skip) { (success, msg, objects) in
            
            if success {
                if let objects = objects {
                    for object in objects {
                        let interested = object as? Interested
                        interested?.post = post
                        interesteds.append(interested!)
                    }
                }
                completionHandler(true, msg, interesteds)
            } else {
                completionHandler(false, msg, nil)
            }
        }
        
    }
    
    static func exitInterestedListOf(profile: Profile, post: Post, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        var queryParams = [String : Any]()
        queryParams[InterestedKeys.user] = profile
        queryParams[InterestedKeys.post] = post
        
        ParseRequest.updateForIsDeletedObjectBy(className: Interested.parseClassName(), queryParams: queryParams) { (success, msg) in
            if success {
                 completionHandler(success, msg)
            } else {
                completionHandler(success, msg)
            }
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
        
        ParseRequest.queryGetAllObjects(className: PostType.parseClassName()) { (success, msg, objects) in
            if success {
                if let objects = objects {
                    objects.forEach {
                        let type = $0 as? PostType
                        allTypes.append(type!)
                    }
                }
                ApplicationState.sharedInstance.postTypes = allTypes
            }
            completionHandler(success, msg)
        }
    }
    
    
    static func getAllConditions (completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        var allConditions = [PostCondition]()
        
        ParseRequest.queryGetAllObjects(className: PostCondition.parseClassName()) { (success, msg, objects) in
            if success {
                if let objects = objects {
                    objects.forEach {
                        let condition = $0 as? PostCondition
                        allConditions.append(condition!)
                    }
                }
                ApplicationState.sharedInstance.postConditions = allConditions
                
            }
            completionHandler(success, msg)
        }
    }
}
