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

struct HomePresenter {
    
    func getFriends(){
        ParseRequest.queryEqualToValue(className: "Follow", key: "from", value: PFUser.current()!) { (success, msg, objects) in
            if success {
                for object in objects! {
                    object.fetchObjectInBackgroundBy(key: "to", completionHandler: { (success, msg, object) in
                        
                        if success {
                            let user = User(user: object as! PFUser)
                            self.following.append(user)
                            self.getPostsOfFriends()
                        } else {
                            print ("ERROR IN FETCH FRIEND")
                        }
                    })
                }
            }
        }
    }
    
    func getPostsOfFriends(){
        
        let filteredFollowing = (self.following.filter { follow in
            return follow.alreadySearched == false
        })
        
        following.filter({$0.alreadySearched == false}).forEach { $0.alreadySearched = true }
        
        ParseRequest.queryContainedIn(className: "Post", key: "author", value: filteredFollowing) { (success, msg, objects) in
            
            if success {
                for obj in objects! {
                    let post = Post(object: obj)
                    self.setAuthorInFriendPost(post: post)
                    self.posts.append(post)
                    self.createBoomerThing()
                    //self.getRelationDatas()
                }
            }
            
            
        }
    }
    
    func createBoomerThing(){
        let filteredPosts = (self.posts.filter { post in
            return post.alreadySearched == false
        })
        
        posts.filter({$0.alreadySearched == false}).forEach { $0.alreadySearched = true }
        
        for post in filteredPosts {
            self.boomerThings.append(BoomerThing(post: post, thingType: .have))
        }
        
        // self.homeTableViewController.loadHomeData(homeBoomerThingsData: ["Meus Amigos" : self.boomerThings])
    }
    
    func setAuthorInFriendPost(post: Post){
        for follower in following {
            if follower.objectId == post.author?.objectId {
                post.author = follower
                return
            }
        }
    }
    
    
    func setUserInformationsInHUD(){
        greetingText.text = "Olar, \(user!.firstName!)"
        
        guard let image = user?.profileImage else {
            self.profileImage.loadAnimation()
            
            user?.getDataInBackgroundBy(key: #keyPath(User.imageFile), completionHandler: { (success, msg, data) in
                self.user?.profileImage = UIImage(data: data!)
                self.profileImage.image = UIImage(data: data!)
                self.profileImage.unload()
                
            })
            
            return
        }
        profileImage.image = image
    }
}
