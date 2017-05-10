//
//  HomePresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 19/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import Foundation
import UIKit
import Parse

class HomePresenter: NSObject {

    fileprivate let pagination = 3
    fileprivate var skipPosts = 0
    fileprivate var skipUsers = 0
    fileprivate var following: [Profile] = [Profile]()
    fileprivate var posts: [Post] = [Post]()
    fileprivate var post: Post = Post()
    fileprivate var controller: ViewDelegate?
    fileprivate var user: User = ApplicationState.sharedInstance.currentUser!
    fileprivate var currentPostsFriendsCount = 0
    
    func setControllerDelegate(controller: ViewDelegate) {
        self.controller = controller
    }
    
    func updatePostsFriends(){
        skipPosts = getPosts().endIndex
        skipUsers = following.endIndex
        getProfile()
        
//        if let _ = user.profile?.firstName {
//            getFriends()
//        } else {
//            getProfile()
//        }
    }
    
    func getProfile() {
        UserRequest.getProfileUser { (success, msg) in
            if success {
                self.requestAllPostTypes(completionHandler: { (success, msg) in
                    if success {
                        self.getFriends()
                    } else {
                        print ("ERROR GET POST TYPES")
                    }
                })
            } else {
                print ("get profile error")
            }
        }
    }
    
    func getFriends() {
        skipUsers = following.endIndex
        UserRequest.fetchFollowing(fromProfile: user.profile!, pagination: pagination, skip: skipUsers, completionHandler: { (success, msg, following) in
            if success {
                for f in following! {
                    self.following.append(f)
                }
                self.getPostsByFriends()
            } else {
                self.controller?.showMessageError(msg: msg)
            }
        })
    }
    
    func getPostsByFriends(){
        PostRequest.fetchPostByFollowing(following: following, pagination: pagination, skip: skipPosts) { (success, msg, posts) in
            if success {
                for post in posts! {
                    self.posts.append(post)
                }
                self.controller?.reload()
                self.currentPostsFriendsCount = self.getPosts().count
            } else {
                self.controller?.showMessageError(msg: msg)
            }
        }
    }
    
    func getUser() -> User{
        return user
    }
    
    func getPosts() -> [Post] {
        return posts
    }
    
    func setPosts(posts: [Post]){
        self.posts = posts
    }
    
    func getPost() -> Post {
        return post
    }
    
    func setPost(post: Post){
        self.post = post
    }
    
    func getCurrentPostsFriendsCount() -> Int {
        return currentPostsFriendsCount
    }
    
    func getFollowing() -> [Profile] {
        return following
    }
    
    func getUserImage(completionHandler: @escaping (_ success: Bool, _ msg: String, _ image: UIImage?) -> Void) {
        guard let image = user.profileImage else {
            user.getDataInBackgroundBy(key: #keyPath(User.photo), completionHandler: { (success, msg, data) in
                
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
    
    
    func getAuthorPhotoOfPost(completionHandler: @escaping (_ success: Bool, _ msg: String, _ image: UIImage?) -> Void){
        guard let image = getPost().author?.profileImage else {
            getPost().author?.getDataInBackgroundBy(key: #keyPath(User.photo), completionHandler: { (success, msg, data) in
                if success {
                    self.getPost().author?.profileImage = UIImage(data: data!)
                    completionHandler(true, msg, self.getPost().author?.profileImage)
                } else {
                    completionHandler(false, msg, nil)
                }
            })
            
            return
        }
        completionHandler(true, "Success", image)
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
    
    func requestAllPostTypes(completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        PostRequest.getAllTypes { (success, msg) in
            completionHandler(success, msg)
        }
    }
}
