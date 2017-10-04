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
    private var delegate: ViewDelegate?
    var following: [Profile] = [Profile]()
    var friendsPosts: [Post] = [Post]()
    var othersPosts: [Post] = [Post]()
    var post: Post = Post()
    var profile: Profile = User.current()!.profile!
    var currentPostsFriendsCount = 0
    var currentSectionPost: SectionPost?
    
    fileprivate let liveQueryClient = ApplicationState.sharedInstance.liveQueryClient
    
    fileprivate var subscriptionFollowCreated: Subscription<Follow>?
    fileprivate var subscriptionFollowUpdated: Subscription<Follow>?
    
    fileprivate var subscriptionPostCreated: Subscription<Post>?
    fileprivate var subscriptionPostUpdated: Subscription<Post>?
    
    
    func setControllerDelegate(delegate: ViewDelegate) {
        self.delegate = delegate
    }
    
    func getTimeLinePosts() {
        self.getFriends()
        self.getPostsOfTheOtherUsers()
        self.getFeaturedPosts()
    }
    
    func getFeaturedPosts() {
        PostRequest.fetchFeaturedPosts(postsDownloaded: self.featuredPosts) { (success, msg, posts) in
            if success {
                posts!.forEach {
                    self.featuredPosts.append($0)
                }
                self.delegate?.reload()
            } else {
                self.delegate?.showMessageError(msg: msg)
            }
        }
    }
    
    fileprivate func getFriends() {
        UserRequest.fetchFollowing(fromProfile: profile, followingDownloaded: self.following, pagination: Paginations.friends) { (success, msg, following) in
            if success {
                if following!.count < 1 {
                    self.following = following!
                    self.friendsPosts = [Post]()
                    self.delegate?.reload()
                } else {
                    for f in following! {
                        self.following.append(f)
                    }
                    self.getPostsByFriends()
                }
            } else {
                self.delegate?.showMessageError(msg: msg)
            }
        }
    }
    
    private func getPostsByFriends(){
        PostRequest.fetchPostByFollowing(postsDownloaded: friendsPosts, following: following, pagination: Paginations.postsByFriends) { (success, msg, posts) in
            if success {
                for post in posts! {
                    self.friendsPosts.append(post)
                }
                self.delegate?.reload()
                self.currentPostsFriendsCount = self.friendsPosts.count
            } else {
                self.delegate?.showMessageError(msg: msg)
            }
        }
    }
    
    private func getPostsOfTheOtherUsers() {
        PostRequest.getPostsThatNotContain(friends: following, pagination: Paginations.postsByCity) { (success, msg, posts) in
            if success {
                posts!.forEach {
                    self.othersPosts.append($0)
                }
                self.delegate?.reload()
            } else {
                self.delegate?.showMessageError(msg: msg)
            }
        }
    }
    fileprivate func appendNewPostInFeatured(post: Post) {
        PostRequest.fetchAuthor(of: post) { (success, msg) in
            if success {
                self.featuredPosts.removeLast()
                self.featuredPosts.insert(post, at: 0)
                self.delegate?.reload()
            }
        }
    }
}

//MARK - Live Querys

extension HomePresenter {
    
    fileprivate var followQuery: PFQuery<Follow>? {
        return (Follow.query()?
            .whereKey(FollowKeys.from, equalTo: profile)
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
                
                for (index, f) in self.following.enumerated() where
                    f.objectId! == follow.objectId! {
                    self.friendsPosts.remove(at: index)
                }

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

