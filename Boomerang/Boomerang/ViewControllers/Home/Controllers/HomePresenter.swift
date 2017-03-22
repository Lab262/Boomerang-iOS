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
    fileprivate var skip = 0
    fileprivate var currentIndex = 0

    fileprivate var following: [User] = [User]()
    fileprivate var posts: [Post] = [Post]()
    fileprivate var boomerThings: [BoomerThing] = [BoomerThing]()
    fileprivate var controller: HomeMainDelegate?
    fileprivate var user: User = ApplicationState.sharedInstance.currentUser!
    fileprivate var postsCount = 0
    
    func setControllerDelegate(controller: HomeMainViewController) {
        self.controller = controller
    }
    
    func updatePostsFriends(currentIndex: Int? = 0){
        self.currentIndex = currentIndex!
        
        if following.count < 1 {
            getFriends()
        } else {
            getPostsByFriends()
        }

    }
    
    func getFriends() {
        UserRequest.fetchFollowing(completionHandler: { (success, msg, following) in
            if success {
                self.following = following!
                
                self.getCountPostsByFriends()
            } else {
                self.controller?.showMessageError(msg: msg)
            }
        })
    }
    
    func getCountPostsByFriends(){
        PostRequest.getFollowingPostsCount(following: following) { (success, msg, count) in
            
            if success {
                self.postsCount = count!
                self.getPostsByFriends()
            } else {
                self.controller?.showMessageError(msg: msg)
            }
        }
    }
    
    func getPostsByFriends() {
        
        PostRequest.fetchPostByFollowing(following: following, pagination: pagination, skip: currentIndex) { (success, msg, posts) in
            if success {
                self.posts = posts!
                self.getBoomerThings()
            } else {
                self.controller?.showMessageError(msg: msg)
            }
        }
    }
    
    func getUser() -> User{
        return user
    }
    
    func getUserImage(completionHandler: @escaping (_ success: Bool, _ msg: String, _ image: UIImage?) -> Void) {
        
        guard let image = user.profileImage else {
            user.getDataInBackgroundBy(key: #keyPath(User.imageFile), completionHandler: { (success, msg, data) in
                
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
    
    func getBoomerThings() {
        for post in filterPosts(){
            boomerThings.append(BoomerThing(post: post, thingType: .have))
        }
        controller?.updatePosts(boomerThings: boomerThings)
    }
    
    func filterFollowing() -> [User] {
        let filteredFollowing = (following.filter { follow in
            return follow.alreadySearched == false
        })
        
        following.filter({$0.alreadySearched == false}).forEach { $0.alreadySearched = true }
        return filteredFollowing
    }
    
    func filterPosts() -> [Post] {
        let filteredPosts = (self.posts.filter { post in
            return post.alreadySearched == false
        })
        
        posts.filter({$0.alreadySearched == false}).forEach { $0.alreadySearched = true }
        return filteredPosts
    }
}
