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
            
          //  self.getThingByPost(post: post)
        })
        

    }
    
    func getPhotoUser(user: User, completionHandler: @escaping (_ success: Bool, _ msg: String, _ photo: UIImage?) -> Void) {
        
            }
    
    func getDataFor(object: PFObject, key: String, completionHandler: @escaping (_ success: Bool, _ msg: String, _ data: Data?) -> Void) {
        
        
        
        
        
//        ParseRequest.getDataFrom(object: object, key: key) { (success, msg, data) in
//            if success {
//                completionHandler(success, msg, data)
//            } else {
//                completionHandler(success, msg, data)
//            }
//        }
    }
    
//        UserRequest.getProfilePhoto(user: user) { (success, msg, photo) in
//            
//            if success {
//                completionHandler(true, msg, photo)
//            }
//        }
//    }
    
    
    func getThingByPost(post: Post){
        
        let thing = post["thing"] as? PFObject
        
        thing?.fetchIfNeededInBackground(block: { (object, error) in
            
            post.thing = Thing(object: object!)
            
            self.getPhotoUser(user: post.author!, completionHandler: { (success, msg, userPhoto) in
                
                if success {
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
                    
                }
            })
            
        })
    }


    func setUserInformationsInHUD(){
        
        greetingText.text = "Olar, \(user!.firstName!)"
        
        guard let image = user?.profileImage else {
            
            self.profileImage.loadAnimation()
            
            user?.getMultipleDataBy(keys: [#keyPath(User.imageFile), #keyPath(User.imageFile)], completionHandler: { (success, msg, datas) in
                
                self.user?.profileImage = UIImage(data: datas![0])
                
                self.profileImage.image = UIImage(data: datas![1])
                
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
