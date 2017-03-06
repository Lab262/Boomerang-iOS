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

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var greetingText: UILabel!
    
    var following = [User]()
    var posts = [Post]()
    
    var user = ApplicationState.sharedInstance.currentUser
    
    @IBAction func showMenu(_ sender: Any) {
        
        TabBarController.showMenu()
    }
    
    func getFriends(){
        
        let query = PFQuery(className: "Follow")
        query.whereKey("from", equalTo: PFUser.current()!)
        
        query.findObjectsInBackground { (objects, error) in
            
            if let objects = objects {
                
                for obj in objects {
                    
                    self.getFetchFriend(follow: obj)
                }
                
                
            }
        }
    }
    
    func getFetchFriend(follow: PFObject){
        
        let friend = follow.object(forKey: "to") as? PFUser
        
        friend?.fetchIfNeededInBackground(block: { (object, error) in
            
            let friend = User(user: object! as! PFUser)
            
            self.following.append(friend)
            
            self.getPostsOfFriends()
            
        })
        

    }
    
    func getPostsOfFriends(){
        
        let query = PFQuery(className: "Post")
        query.whereKey("author", equalTo: following.first!)
        
        query.findObjectsInBackground { (objects, error) in
            
            if let objects = objects {
                
                for obj in objects {
                    
                    let post = Post(object: obj)
                    self.posts.append(post)
                }
                
                self.getAuthorByPost(post: self.posts.first!)
            }
        }
    }
    
    func getAuthorByPost(post: Post){
        
        let author = post["author"] as? PFUser
        
        author?.fetchIfNeededInBackground(block: { (object, error) in
            
            post.author = User(user: object as! PFUser)
            
            self.getThingByPost(post: post)
        })
        

    }
    
    func getPhotoUser(user: User, completionHandler: @escaping (_ success: Bool, _ msg: String, _ photo: UIImage?) -> Void) {
        
        UserRequest.getProfilePhoto(user: user) { (success, msg, photo) in
            
            if success {
                completionHandler(true, msg, photo)
            }
        }
    }
    
    func getPhotoThing(thing: Thing, completionHandler: @escaping (_ success: Bool, _ msg: String, _ photo: UIImage?) -> Void) {
        
        UserRequest.getThingPhoto(thing: thing) { (success, msg, photo) in
            
            if success {
                completionHandler(true, msg, photo)
            }
        }
    }

    
    func getThingByPost(post: Post){
        
        let thing = post["thing"] as? PFObject
        
        thing?.fetchIfNeededInBackground(block: { (object, error) in
            
            post.thing = Thing(object: object!)
            
            self.getPhotoUser(user: post.author!, completionHandler: { (success, msg, userPhoto) in
                
                if success {
                    
                    self.getPhotoThing(thing: post.thing!, completionHandler: { (success, msg, thingPhoto) in
                        
                         let boomerThing1 = BoomerThing(thingPhoto: thingPhoto!, thingDescription: post.content!, profilePhoto: userPhoto!, profileName: post.author!.firstName! + " " + post.author!.lastName!, thingType: .need)
                        
                        self.homeBoomerThingsData = [
                            "Meus amigos" : [boomerThing1, boomerThing1],
                            "Brasília - DF" : [boomerThing1],
                            "Recomendados para voce" : [boomerThing1, boomerThing1,boomerThing1]]
                        
                        
                         self.homeTableViewController.loadHomeData(homeBoomerThingsData: self.homeBoomerThingsData)

                    })
                    
                 
                    
                    
               
                    
                }
            })
            

//            
////                    let boomerThing2 = BoomerThing(thingPhoto: #imageLiteral(resourceName: "foto_dummy"), thingDescription: "Ofereço um longboard freehide", profilePhoto: #imageLiteral(resourceName: "profile_dummy"), profileName: "Thiago Bernardes", thingType: .have)
////                    let boomerThing3 = BoomerThing(thingPhoto: #imageLiteral(resourceName: "foto_dummy"), thingDescription: "Um mangá", profilePhoto: #imageLiteral(resourceName: "profile_dummy"), profileName: "Huallyd Smadi", thingType: .need)
////                    let boomerThing4 = BoomerThing(thingPhoto: #imageLiteral(resourceName: "foto_dummy"), thingDescription: "Aulas de como ser foda", profilePhoto: #imageLiteral(resourceName: "profile_dummy"), profileName: "Janaina na aaaa aaa", thingType: .experience)
//            
//            self.homeBoomerThingsData = [
//                "Meus amigos" : [post, post],
//                "Brasília - DF" : [post],
//                "Recomendados para voce" : [post, post,post]]
            

            
        })
    }
    

    func loadDummyData() {
        
        
        
//        let boomerThing1 = BoomerThing(thingPhoto: #imageLiteral(resourceName: "foto_dummy"), thingDescription: "Preciso de um app para o boomerang", profilePhoto: #imageLiteral(resourceName: "profile_dummy"), profileName: "Amanda Elys", thingType: .need)
//        let boomerThing2 = BoomerThing(thingPhoto: #imageLiteral(resourceName: "foto_dummy"), thingDescription: "Ofereço um longboard freehide", profilePhoto: #imageLiteral(resourceName: "profile_dummy"), profileName: "Thiago Bernardes", thingType: .have)
//        let boomerThing3 = BoomerThing(thingPhoto: #imageLiteral(resourceName: "foto_dummy"), thingDescription: "Um mangá", profilePhoto: #imageLiteral(resourceName: "profile_dummy"), profileName: "Huallyd Smadi", thingType: .need)
//        let boomerThing4 = BoomerThing(thingPhoto: #imageLiteral(resourceName: "foto_dummy"), thingDescription: "Aulas de como ser foda", profilePhoto: #imageLiteral(resourceName: "profile_dummy"), profileName: "Janaina na aaaa aaa", thingType: .experience)
        
    }
    

    func setUserInformationsInHUD(){
        
        greetingText.text = "Olar, \(user!.firstName!)"
        
        guard let image = user?.profileImage else {
            profileImage.loadAnimation()
            
            UserRequest.getProfilePhoto(user: user!, completionHandler: { (success, msg, photo) in
                
                if success {
                    self.user?.profileImage = photo
                    self.profileImage.image = photo
                    self.profileImage.unload()
                } else {
                    
                }
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
        
        self.loadDummyData()
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
