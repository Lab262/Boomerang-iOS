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
    fileprivate var following: [User] = [User]()
    fileprivate var posts: [Post] = [Post]()
    fileprivate var controller: ViewControllerDelegate?
    fileprivate var user: User = ApplicationState.sharedInstance.currentUser!
    fileprivate var postsCount = 0
    
    func setControllerDelegate(controller: ViewControllerDelegate) {
        self.controller = controller
    }
    
    func updatePostsFriends(){
        skipPosts = posts.endIndex
        skipUsers = following.endIndex
        
        getFriends()
        
    }
    
    func getFriends() {
        skipUsers = following.endIndex
        
        UserRequest.fetchFollowing(pagination: pagination, skip: skipUsers, completionHandler: { (success, msg, following) in
            if success {
                self.following = following!
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
                self.controller?.updateView(array: self.posts)
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
}
