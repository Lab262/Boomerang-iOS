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

    private var featuredPosts = [Post]()
    private var view: ViewDelegate?
    var following: [Profile] = [Profile]()
    var friendsPosts: [Post] = [Post]()
    var othersPosts: [Post] = [Post]()
    var post: Post = Post()
    var user: User = ApplicationState.sharedInstance.currentUser!
    var currentPostsFriendsCount = 0
    
    func setControllerDelegate(view: ViewDelegate) {
        self.view = view
    }
    
    func getTimeLinePosts() {
        getProfile()
    }
    
    func getFeaturedPosts() -> [Post] {
        featuredPosts = [Post]()
        let allPosts = friendsPosts + othersPosts
        for post in allPosts where post.isFeatured! {
            featuredPosts.append(post)
        }
        return featuredPosts
    }
    
    
    private func getAllPostTypes() {
        requestAllPostTypes(completionHandler: { (success, msg) in
            if success {
                self.getAllPostConditions()
            } else {
                self.view?.showMessageError(msg: msg)
            }
        })
    }
    
    private func getAllPostConditions() {
        requestAllPostConditions(completionHandler: { (success, msg) in
            if success {
                self.getAllSchemeStatus()
            } else {
                self.view?.showMessageError(msg: msg)
            }
        })
    }
    
    
    private func getAllSchemeStatus() {
        requestSchemeStatus(completionHandler: { (success, msg) in
            if success {
                self.getFriends()
                self.getPostsOfTheOtherUsers()
            } else {
                self.view?.showMessageError(msg: msg)
            }
        })
    }
    
    private func getProfile() {
        UserRequest.getProfileUser { (success, msg) in
            if success {
                self.getAllPostTypes()
            } else {
                self.view?.showMessageError(msg: msg)
            }
        }
    }
    
    private func getFriends() {
        UserRequest.fetchFollowing(fromProfile: user.profile!, followingDownloaded: self.following, pagination: Paginations.friends) { (success, msg, following) in
            if success {
                for f in following! {
                    self.following.append(f)
                }
                self.getPostsByFriends()
            } else {
                self.view?.showMessageError(msg: msg)
            }
        }
    }
    
    private func getPostsByFriends(){
        PostRequest.fetchPostByFollowing(postsDownloaded: friendsPosts, following: following, pagination: Paginations.postsByFriends) { (success, msg, posts) in
            if success {
                for post in posts! {
                    self.friendsPosts.append(post)
                }
                self.view?.reload()
                self.currentPostsFriendsCount = self.friendsPosts.count
            } else {
                self.view?.showMessageError(msg: msg)
            }
        }
    }
    
    private func getPostsOfTheOtherUsers() {
        PostRequest.getPostsThatNotContain(friends: following, pagination: Paginations.postsByCity) { (success, msg, posts) in
            if success {
                posts!.forEach {
                    self.othersPosts.append($0)
                }
                self.view?.reload()
            } else {
                self.view?.showMessageError(msg: msg)
            }
        }
    }
    
    private func requestAllPostTypes(completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        PostRequest.getAllTypes { (success, msg) in
            completionHandler(success, msg)
        }
    }
    
    private func requestAllPostConditions(completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        PostRequest.getAllConditions { (success, msg) in
            completionHandler(success, msg)
        }
    }
    
    private func requestSchemeStatus(completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        SchemeRequest.getAllStatus { (success, msg) in
            completionHandler(success, msg)
        }
    }
}
