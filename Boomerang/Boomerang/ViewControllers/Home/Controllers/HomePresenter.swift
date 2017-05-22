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
import ParseLiveQuery

class HomePresenter: NSObject {

    var featuredPosts = [Post]()
    private var view: ViewDelegate?
    var following: [Profile] = [Profile]()
    var friendsPosts: [Post] = [Post]()
    var othersPosts: [Post] = [Post]()
    var post: Post = Post()
    var user: User = ApplicationState.sharedInstance.currentUser!
    var currentPostsFriendsCount = 0
    
    fileprivate let liveQueryClient = ApplicationState.sharedInstance.liveQueryClient
    
    fileprivate var subscriptionFollowCreated: Subscription<Follow>?
    
    fileprivate var subscriptionFollowUpdated: Subscription<Follow>?
    
    func setControllerDelegate(view: ViewDelegate) {
        self.view = view
    }
    
    func getTimeLinePosts() {
        getProfile()
    }
    
//    func getFeaturedPosts() -> [Post] {
//        featuredPosts = [Post]()
//        let allPosts = friendsPosts + othersPosts
//        for post in allPosts where post.isFeatured! {
//            featuredPosts.append(post)
//        }
//        return featuredPosts
//    }
//    
    func getFeaturedPosts() {
        PostRequest.fetchFeaturedPosts { (success, msg, posts) in
            if success {
                posts!.forEach {
                    self.featuredPosts.append($0)
                }
                self.view?.reload()
            } else {
                self.view?.showMessageError(msg: msg)
            }
        }
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
                self.getFeaturedPosts()
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
    
    fileprivate func getFriends() {
        UserRequest.fetchFollowing(fromProfile: user.profile!, followingDownloaded: self.following, pagination: Paginations.friends) { (success, msg, following) in
            if success {
                if following!.count < 1 {
                    self.following = following!
                    self.friendsPosts = [Post]()
                    self.view?.reload()
                } else {
                    for f in following! {
                        self.following.append(f)
                    }
                    self.getPostsByFriends()
                }
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

//MARK - Live Querys

extension HomePresenter {
    
    var followQuery: PFQuery<Follow>? {
        return (Follow.query()?
            .whereKey("from", equalTo: self.user.profile!)
            .order(byAscending: "createdAt") as! PFQuery<Follow>)
    }
    
    func subscribeToUpdateFollow() {
        
        subscriptionFollowCreated = liveQueryClient
            .subscribe(followQuery!)
            .handle(Event.created) { _, follow in
                self.getFriends()
        }
        
        subscriptionFollowUpdated = liveQueryClient
            .subscribe(followQuery!)
            .handle(Event.updated) { _, follow in
                self.getFriends()
        }
    }
    
    func printMessage(follow: Follow) {
        
    }
}

