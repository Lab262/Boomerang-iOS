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
    
            self.homeTableViewController.loadHomeData(homeBoomerThingsData: ["Meus Amigos" : self.boomerThings])
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
