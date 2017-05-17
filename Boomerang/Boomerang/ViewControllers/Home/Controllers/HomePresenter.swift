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

    let pagination = 3
    var following: [Profile] = [Profile]()
    var friendsPosts: [Post] = [Post]()
    var othersPosts: [Post] = [Post]()
    private var featuredPosts = [Post]()
    var post: Post = Post()
    var controller: ViewDelegate?
    var user: User = ApplicationState.sharedInstance.currentUser!
    var currentPostsFriendsCount = 0
    
    func setControllerDelegate(controller: ViewDelegate) {
        self.controller = controller
    }
    
    func updatePostsFriends(){
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
                        self.requestAllPostConditions(completionHandler: { (success, msg) in
                            self.requestSchemeStatus(completionHandler: { (success, msg) in
                                if success {
                                    if success {
                                        self.getFriends()
                                    } else {
                                        print ("ERROR GET POST CONDITIONS \(msg)")
                                    }
                                }
                            })
                        })
                    } else {
                        print ("ERROR GET POST TYPES")
                    }
                })
            } else {
                print ("get profile error")
            }
        }
    }
    
    func getFeaturedPosts() -> [Post] {
        featuredPosts = [Post]()
        
        let allPosts = friendsPosts + othersPosts
        for post in allPosts where post.isFeatured! {
            featuredPosts.append(post)
        }
        return featuredPosts
    }
    
    func getFriends() {        
        UserRequest.fetchFollowing(fromProfile: user.profile!, followingDownloaded: self.following, pagination: pagination) { (success, msg, following) in
            
            if success {
                for f in following! {
                    self.following.append(f)
                }
                self.getPostsByFriends()
            } else {
                self.controller?.showMessageError(msg: msg)
            }
        }
    }
    
    func getPostsByFriends(){
        PostRequest.fetchPostByFollowing(postsDownloaded: friendsPosts, following: following, pagination: pagination) { (success, msg, posts) in
            if success {
                for post in posts! {
                    self.friendsPosts.append(post)
                }
                self.controller?.reload()
                self.currentPostsFriendsCount = self.friendsPosts.count
            } else {
                self.controller?.showMessageError(msg: msg)
            }
        }
    }
    
    func getPostsOfTheOtherUsers() {
        PostRequest.getPostsThatNotContain(friends: following, pagination: pagination) { (success, msg, posts) in
            if success {
                posts!.forEach {
                    self.othersPosts.append($0)
                }
                self.controller?.reload()
            } else {
                self.controller?.showMessageError(msg: msg)
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
    
    
    
    func requestAllPostTypes(completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        PostRequest.getAllTypes { (success, msg) in
            completionHandler(success, msg)
        }
    }
    
    func requestAllPostConditions(completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        PostRequest.getAllConditions { (success, msg) in
            completionHandler(success, msg)
        }
    }
    
    func requestSchemeStatus(completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        SchemeRequest.getAllStatus { (success, msg) in
            completionHandler(success, msg)
        }
    }
}
