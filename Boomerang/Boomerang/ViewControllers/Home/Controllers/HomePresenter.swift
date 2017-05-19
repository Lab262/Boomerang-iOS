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

    var following: [Profile] = [Profile]()
    var friendsPosts: [Post] = [Post]()
    var othersPosts: [Post] = [Post]()
    private var featuredPosts = [Post]()
    var post: Post = Post()
    private var view: ViewDelegate?
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
