//
//  ProfilePresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 04/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class ProfilePresenter: NSObject {
    
//    fileprivate var user: User = ApplicationState.sharedInstance.currentUser!
    fileprivate var profile: Profile = ApplicationState.sharedInstance.currentUser!.profile!
    fileprivate let pagination = 20
    fileprivate var skip = 0
    fileprivate var allPosts: [Post] = [Post]()
    fileprivate var needPosts: [Post] = [Post]()
    fileprivate var havePosts: [Post] = [Post]()
    fileprivate var donatePosts: [Post] = [Post]()
    fileprivate var currentPostType: PostType? = nil
    fileprivate var post: Post = Post() {
        didSet{
            profile = post.author!
        }
    }
    fileprivate var currentPostsCount = 0
    fileprivate var controller: ViewDelegate?
    
    
    func setControllerDelegate(controller: ViewDelegate) {
        self.controller = controller
    }
    
    func getUserImage(completionHandler: @escaping (_ success: Bool, _ msg: String, _ image: UIImage?) -> Void) {
        guard let image = profile.profileImage else {
            profile.getDataInBackgroundBy(key: #keyPath(Profile.photo), completionHandler: { (success, msg, data) in
                if success {
                    completionHandler(true, "Success", UIImage(data: data!)!)
                } else {
                    completionHandler(false, msg, nil)
                }
            })
            return
        }
        completionHandler(true, "Success", image)
    }
    
    func getCurrentPostsCount() -> Int {
        return currentPostsCount
    }
    
    func setProfile(profile:Profile){
        self.profile = profile
    }
    
    func getProfile() -> Profile{
        return profile
    }
    
    func getAllPosts() -> [Post] {
        return allPosts
    }
    
    func setCurrentPostType(postType: PostType?) {
        currentPostType = postType
    }
    
    func getCurrentPostType() -> PostType? {
        return currentPostType
    }
    
    func getPostsBy(postType: PostType?) -> [Post] {
        if let type = postType {
            return filterPostsFor(postType:type)
        } else {
            return allPosts
        }
    }
    
    func followUser(completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()){
        
        let follow = Follow(from: ApplicationState.sharedInstance.currentUser!.profile!, to: profile)
        
        follow.saveObjectInBackground { (success, msg) in
            if success {
                completionHandler(true, "success")
            } else {
                completionHandler(false, msg)
            }
        }
    }
    
    func unfollowUser(completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()){
        
        UserRequest.unfollowUser(currentProfile: ApplicationState.sharedInstance.currentUser!.profile!, otherProfile: profile) { (success, msg) in
            if success {
                completionHandler(true, msg)
            } else {
                completionHandler(false, msg)
            }
        }
    }
    
    func authorPostIsCurrent() -> Bool {
        
        if self.profile.objectId == ApplicationState.sharedInstance.currentUser?.profile?.objectId {
            return true
        } else {
            return false
        }
    }
    
    func getPostsForCurrentFilter() -> [Post] {
        return getPostsBy(postType: currentPostType)
    }
    
    func setAllPosts(posts: [Post]){
        self.allPosts = posts
    }
    
    func getPost() -> Post {
        return post
    }
    
    func setPost(post: Post){
        self.post = post
    }
    
    func updatePosts(){
        skip = allPosts.endIndex
        getPostsOfUser()
    }
    
    func alreadyFollowing(completionHandler: @escaping (_ success: Bool, _ msg: String, _ alreadyFollow: Bool?) -> ()){
        
        UserRequest.verifyAlreadyFollowingFor(currentProfile: ApplicationState.sharedInstance.currentUser!.profile!, otherProfile: profile) { (success, msg, alreadyFollow) in
            
            if success {
                completionHandler(true, msg, alreadyFollow)
            } else {
                completionHandler(false, msg, alreadyFollow)
            }
        }
    }
    
    func getUserCountOf(key: String, className: String, completionHandler: @escaping (_ success: Bool, _ msg: String, _ count: Int?) -> Void){
        
        UserRequest.getProfileCountOf(key: key, className: className, profile: profile) { (success, msg, count) in
            if success {
                completionHandler(true, msg, count)
            } else {
                completionHandler(false, msg, nil)
            }
        }
    }
    
    func getPostsOfUser(){
        PostRequest.getPostsFor(profile: getProfile(), pagination: pagination, skip: skip) { (success, msg, posts) in
            if success {
                for post in posts! {
                    self.allPosts.append(post)
                }
                self.controller?.reload()
                self.currentPostsCount = self.getPostsBy(postType: self.currentPostType).count
            } else {
                self.controller?.showMessageError(msg: msg)
            }
        }
    }
    
    func filterPostsFor(postType: PostType) -> [Post] {
        
        let filteredPosts = (self.allPosts.filter { post in
            return post.postType == postType
        })
        
        currentPostType = postType
        
        return filteredPosts
    }
    
    func getCountPhotos(){
        if getPost().countPhotos < 1 {
            getPost().getRelationCountInBackgroundBy(key: "photos", completionHandler: { (success, msg, count) in
                if success {
                    self.getPost().countPhotos = count!
                    ApplicationState.sharedInstance.callDelegateUpdate(post: self.getPost(), success: true, updateType: .amount)
                } else {
                    ApplicationState.sharedInstance.callDelegateUpdate(post: nil, success: true, updateType: .amount)
                }
            })
        }
    }
    
    
    func getCoverOfPost(completionHandler: @escaping (_ success: Bool, _ msg: String, _ image: UIImage?) -> Void){
        
        PostRequest.getRelationsInBackground(post: getPost()) { (success, msg) in
            if success {
                self.downloadCoverImagePost(completionHandler: { (success, msg, image) in
                    completionHandler(success, msg, image)
                })
            } else {
                completionHandler(false, msg, nil)
            }
        }
    }
    
    func downloadCoverImagePost(completionHandler: @escaping (_ success: Bool, _ msg: String, _ image: UIImage?) -> Void){
        if let relations = getPost().relations {
            guard let cover = relations.first?.photo else {
                relations.first?.getDataInBackgroundBy(key: "imageFile", completionHandler: { (success, msg, data) in
                    
                    if success {
                        relations.first?.photo = UIImage(data: data!)
                        relations.first?.isDownloadedImage = true
                        completionHandler(success, msg, relations.first?.photo)
                    } else {
                        completionHandler(success, msg, nil)
                    }
                })
                return
            }
            
            completionHandler(true, "success", cover)
        }
    }
    
}
