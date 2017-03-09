//
//  HomeMainViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 03/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import Parse

class HomeMainViewController: UIViewController {

    internal var homeTableViewController: HomeTableViewController!
    internal var homeBoomerThingsData = [String: [BoomerThing]]()
    internal var boomerThings = [BoomerThing]()
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var greetingText: UILabel!
    
    var following = [User]()
    var posts = [Post]()
    
    var user = ApplicationState.sharedInstance.currentUser
    
    @IBAction func showMenu(_ sender: Any) {
        TabBarController.showMenu()
    }
    
    func getFriends(){
        ParseRequest.queryEqualToValue(className: "Follow", key: "from", value: PFUser.current()!) { (success, msg, objects) in
            
            if success {
                for object in objects! {
                    if let friend = object.fetchObjectBy(key: "to") {
                        
                        friend.getDataInBackgroundBy(key: #keyPath(User.imageFile), completionHandler: { (success, msg, data) in
                            
                            if success {
                                (friend as! User).profileImage = UIImage(data: data!)
                                self.following.append(friend as! User)
                                self.getPostsOfFriends()
                                
                            } else {
                                print ("FALHA NA FOTO DE FRIEND")
                            }
                        })
                    }
                }
            
                
            }
        }
    }
    
    //                    object.fetchObjectInBackgroundBy(key: "to", completionHandler: { (success, msg, object) in
    //
    //                        if success {
    //                            self.following.append(User(user: object as! PFUser))
    //
    //
    //
    //                        }
    //                    })
    
    func getFetchFriend(follow: PFObject){
        let friend = follow.object(forKey: "to") as? PFUser
        
        friend?.fetchIfNeededInBackground(block: { (object, error) in
            
            let friend = User(user: object! as! PFUser)
            
            friend.getDataInBackgroundBy(key: #keyPath(User.imageFile), completionHandler: { (success, msg, data) in
                
                if success {
                    friend.profileImage = UIImage(data: data!)
                    self.following.append(friend)
                    self.getPostsOfFriends()
                    
                } else {
                    print ("FALHA NA FOTO DE FRIEND")
                }
            })
            
        })
    }
    
    func getPostsOfFriends(){
        
        ParseRequest.queryContainedIn(className: "Post", key: "author", value: self.following) { (success, msg, objects) in
        
            if success {
                for obj in objects! {
                    let post = Post(object: obj)
                    self.setAuthorInFriendPost(post: post)
                    self.posts.append(post)
                }
            }
            
          self.getRelationDatas()
        }
    }
    
    func getRelationDatas(){
        
        for post in posts {
            post.photos = [UIImage]()
            if let datas = post.getRelationWithDataBy(key: "photos", keyFile: "imageFile") {
                for data in datas {
                    post.photos?.append(UIImage(data: data)!)
//                    post.photos.append(UIImage(data: data)!)
                }
            }
        }
        
        for post in posts {
            
            print ("POSTS COUNT: \(posts.count)")
            print ("POST: photos: \(post.photos) content: \(post.content) profile photo: \(post.author?.profileImage) profile name: \(post.author?.name)")
            
            self.boomerThings.append(BoomerThing(thingPhoto: post.photos![0], thingDescription: post.content!, profilePhoto: post.author!.profileImage!, profileName: post.author!.username!, thingType: .have))
        }
        
        self.homeBoomerThingsData = ["Meus Amigos" : self.boomerThings, "Brasilia - DF" : self.boomerThings]
        
        self.homeTableViewController.loadHomeData(homeBoomerThingsData: self.homeBoomerThingsData)
        
       
        //
        //                        self.homeBoomerThingsData = [
        //                            "Meus amigos" : [boomerThing1, boomerThing1],
        //                            "Brasília - DF" : [boomerThing1],
        //                            "Recomendados para voce" : [boomerThing1, boomerThing1,boomerThing1]]
        //
        //
        //

    }
    
    func setAuthorInFriendPost(post: Post){
        for follower in following {
            if follower.objectId == post.author?.objectId {
                post.author = follower
                return
            }
        }
    }
    
    
    func getPhotoUser(user: User, completionHandler: @escaping (_ success: Bool, _ msg: String, _ photo: UIImage?) -> Void) {
        
            }
    
    func getDataFor(object: PFObject, key: String, completionHandler: @escaping (_ success: Bool, _ msg: String, _ data: Data?) -> Void) {
        
        
    }


    func getThingByPost(post: Post){
        
//        
//        
//        let thing = post["thing"] as? PFObject
//        
//        thing?.fetchIfNeededInBackground(block: { (object, error) in
//            
//            post.thing = Thing(object: object!)
//            
//            self.getPhotoUser(user: post.author!, completionHandler: { (success, msg, userPhoto) in
//                
//                if success {
//
//                    self.getPhotoThing(thing: post.thing!, completionHandler: { (success, msg, thingPhoto) in
//                        
//                         let boomerThing1 = BoomerThing(thingPhoto: thingPhoto!, thingDescription: post.content!, profilePhoto: userPhoto!, profileName: post.author!.firstName! + " " + post.author!.lastName!, thingType: .need)
//                        
//                        self.homeBoomerThingsData = [
//                            "Meus amigos" : [boomerThing1, boomerThing1],
//                            "Brasília - DF" : [boomerThing1],
//                            "Recomendados para voce" : [boomerThing1, boomerThing1,boomerThing1]]
//                        
//                        
//                         self.homeTableViewController.loadHomeData(homeBoomerThingsData: self.homeBoomerThingsData)
//
//                    })
                    
//                }
//            })
        
        //})
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.setUserInformationsInHUD()
        self.getFriends()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
     
       // self.homeTableViewController.loadHomeData(homeBoomerThingsData: homeBoomerThingsData)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.window?.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? HomeTableViewController {
            self.homeTableViewController = controller
        }
    }
    
}
