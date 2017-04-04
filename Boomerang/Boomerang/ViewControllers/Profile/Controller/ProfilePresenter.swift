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

    fileprivate var user: User = ApplicationState.sharedInstance.currentUser!
    fileprivate let pagination = 3
    fileprivate var skip = 0
    fileprivate var posts: [Post] = [Post]()
    fileprivate var post: Post = Post()
    fileprivate var currentPostsCount = 0
    fileprivate var controller: ViewDelegate?
    
    
    func setControllerDelegate(controller: ViewDelegate) {
        self.controller = controller
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
    
    func getCurrentPostsCount() -> Int {
        return currentPostsCount
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
    
    func updatePosts(){
        skip = getPosts().endIndex
        getPostsUser()
    }
    
    func getPostsUser(){
        PostRequest.getPostsFor(user: getUser(), pagination: pagination, skip: skip) { (success, msg, posts) in
            if success {
                for post in posts! {
                    self.posts.append(post)
                }
                self.controller?.reload()
                self.currentPostsCount = self.getPosts().count
            } else {
                self.controller?.showMessageError(msg: msg)
            }
        }
    }

}
