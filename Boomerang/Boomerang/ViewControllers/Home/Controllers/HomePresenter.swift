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
    
    var following: [User] = [User]()
    var posts: [Post] = [Post]()
    var boomerThings: [BoomerThing] = [BoomerThing]()
    var controller: HomeMainDelegate?
    
    func setControllerDelegate(controller: HomeMainViewController) {
        self.controller = controller
    }
    
    func updatePostsFriends(){
        
    }
    
    func getFriends(completionHandler: @escaping (_ success: Bool, _ msg: String, _ following: [User]?) -> Void) {
        UserRequest.fetchFollowing(completionHandler: { (success, msg, following) in
            if success {
                self.following = following!
                completionHandler(true, "Success", self.following)
            } else {
                completionHandler(false, msg.debugDescription, nil)
            }
        })
    }
    
    func getPostsByFriends(completionHandler: @escaping (_ success: Bool, _ msg: String, _ posts: [Post]?) -> Void) {
        
        PostRequest.fetchPostByFollowing(following: filterFollowing()) { (success, msg, posts) in
            if success {
                self.posts = posts!
                completionHandler(true, "Success", self.posts)
            } else {
                completionHandler(false, "Success", nil)
            }
        }
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
    
//
//    func createBoomerThing(){
//        let filteredPosts = (self.posts.filter { post in
//            return post.alreadySearched == false
//        })
//        
//        posts.filter({$0.alreadySearched == false}).forEach { $0.alreadySearched = true }
//        
//        for post in filteredPosts {
//            self.boomerThings.append(BoomerThing(post: post, thingType: .have))
//        }
//        
//        // self.homeTableViewController.loadHomeData(homeBoomerThingsData: ["Meus Amigos" : self.boomerThings])
//    }
//
//    
//    
//    func setUserInformationsInHUD(){
//        greetingText.text = "Olar, \(user!.firstName!)"
//        
//        guard let image = user?.profileImage else {
//            self.profileImage.loadAnimation()
//            
//            user?.getDataInBackgroundBy(key: #keyPath(User.imageFile), completionHandler: { (success, msg, data) in
//                self.user?.profileImage = UIImage(data: data!)
//                self.profileImage.image = UIImage(data: data!)
//                self.profileImage.unload()
//                
//            })
//            
//            return
//        }
//        profileImage.image = image
//    }
}
