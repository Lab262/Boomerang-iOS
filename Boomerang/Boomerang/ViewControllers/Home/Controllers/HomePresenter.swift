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
    
    fileprivate var subscriptionPostCreated: Subscription<Post>?
    fileprivate var subscriptionPostUpdated: Subscription<Post>?
    
    //var liveQuerySetups: [(query: PFQuery<PFObject>, event: Event<T>, theFunction: ())]?  // someTuple is of type (top: Int, bottom: Int)
    
    //var liveQuerySetups = [(query: followQuery, event: Event.created, theFunction: self.getFriends()), (query: followQuery, event: Event.updated, theFunction: self.getFriends())]
    
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
        PostRequest.fetchFeaturedPosts(postsDownloaded: self.featuredPosts) { (success, msg, posts) in
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
    
    fileprivate func appendNewPostInFeatured(post: Post) {
        self.featuredPosts.removeLast()
        self.featuredPosts.insert(post, at: 0)
        self.view?.reload()
    }
}

//MARK - Live Querys

extension HomePresenter {
    
    fileprivate var followQuery: PFQuery<Follow>? {
        return (Follow.query()?
            .whereKey(FollowKeys.from, equalTo: self.user.profile!)
            .order(byAscending: ObjectKeys.createdAt) as! PFQuery<Follow>)
    }
    
    fileprivate var postQuery: PFQuery<Post>? {
        var objectIds = [String]()
        self.featuredPosts.forEach {
            objectIds.append($0.objectId!)
        }
        return (Post.query()?.whereKey("objectId", notContainedIn: objectIds).order(byDescending: ObjectKeys.createdAt) as! PFQuery<Post>)
    }
    
    func setupSubscribes() {
        subscribeToFollow()
        subscribeToPosts()
    }

    func subscribeToFollow() {
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
    
    func subscribeToPosts() {
        subscriptionPostCreated = liveQueryClient
            .subscribe(postQuery!)
            .handle(Event.created) { _, post in
                self.appendNewPostInFeatured(post: post)
        }
        
        subscriptionPostUpdated = liveQueryClient
            .subscribe(postQuery!)
            .handle(Event.updated) { _, post in
               
        }
    }
    
    fileprivate func printMessage(follow: Follow) {
        
    }
}

