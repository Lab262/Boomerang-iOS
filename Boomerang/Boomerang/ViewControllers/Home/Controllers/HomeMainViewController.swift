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
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var tableView: UITableView!

    let tableViewTopInset: CGFloat = 140.0

    var following = [User]()
    var posts = [Post]()
    
    var user = ApplicationState.sharedInstance.currentUser
    
    @IBAction func showMenu(_ sender: Any) {
        TabBarController.showMenu()
    }
    
        override func viewWillAppear(_ animated: Bool) {
            self.setUserInformationsInHUD()
            self.getFriends()
        }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationController?.navigationBar.isHidden = true
            registerNib()
            tableView.contentInset = UIEdgeInsetsMake(tableViewTopInset, 0, 0, 0)
        }
    
    func registerNib() {
        self.tableView.register(UINib(nibName: HomeCollectionHeader.cellIdentifier, bundle: nil), forCellReuseIdentifier: HomeCollectionHeader.cellIdentifier)
        self.tableView.register(UINib(nibName: BoomerThingCollection.cellIdentifier, bundle: nil), forCellReuseIdentifier: BoomerThingCollection.cellIdentifier)
        tableView.registerNibFrom(RecommendedPostTableViewCell.self)
    }
    
    func loadHomeData(homeBoomerThingsData: [String: [BoomerThing]]) {
        
        self.homeBoomerThingsData = homeBoomerThingsData
        self.tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.window?.endEditing(true)
    }
}

extension HomeMainViewController: UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 0
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RecommendedPostTableViewCell.identifier, for: indexPath)
        //        let cell = tableView.dequeueReusableCell(
        //            withIdentifier: BoomerThingCollection.cellIdentifier,
        //            for: indexPath) as! BoomerThingCollection
        //
        //        cell.thingsData = self.homeBoomerThingsData.dataAtKeyAtIndex(
        //            index: indexPath.section) as! [BoomerThing]
        //
        //        self.boomerThingDelegate = cell
        //
        //        cell.selectionDelegate = self
        
        return cell
    }
    
}

extension HomeMainViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = generateHeaderTitle(tableView, viewForHeaderInSection: section)
        
        switch section {
        case 0:
            return nil
        case 1:
            header?.titleLabel.text = "Meus migos"
        default:
            return nil
            
        }
        
        return header
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 300
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return 0
        case 1:
            return 40
        default:
            return 0
        }
    }
}


extension HomeMainViewController {
    
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

extension HomeMainViewController {
    
    func generateHeaderTitle(_ tableView: UITableView, viewForHeaderInSection section: Int) -> HomeCollectionHeader? {
        
        let header = tableView.dequeueReusableCell(withIdentifier:HomeCollectionHeader.cellIdentifier) as! HomeCollectionHeader
        
        return header
        
    }

}

//extension HomeTableViewController: CollectionViewSelectionDelegate {
//    
//    func collectionViewDelegate(_ colletionViewDelegate: UICollectionViewDelegate, didSelectItemAt indexPath: IndexPath) {
//        
//        if colletionViewDelegate === boomerThingDelegate {
//            self.performSegue(withIdentifier: "showDetailThing", sender: self)
//        } else {
//            
//        }
//    }
//}



//    override func viewWillAppear(_ animated: Bool) {
//        self.setUserInformationsInHUD()
//        self.getFriends()
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = true
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.window?.endEditing(true)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if let controller = segue.destination as? HomeTableViewController {
//            self.homeTableViewController = controller
//        }
//    }


