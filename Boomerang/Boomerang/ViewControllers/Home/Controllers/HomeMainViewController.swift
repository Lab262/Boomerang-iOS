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
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    internal var boomerThings = [BoomerThing]()
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var greetingText: UILabel!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var tableView: UITableView!

    let tableViewTopInset: CGFloat = 5.0

    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
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
        
        self.searchBar.setBackgroundImage(ViewUtil.imageFromColor(.clear, forSize:searchBar.frame.size, withCornerRadius: 0), for: .any, barMetrics: .default)
        //self.searchBar.opacity
        
        registerNib()
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func registerNib() {
        self.tableView.register(UINib(nibName: HomeCollectionHeader.cellIdentifier, bundle: nil), forCellReuseIdentifier: HomeCollectionHeader.cellIdentifier)
        self.tableView.register(UINib(nibName: BoomerThingCollection.cellIdentifier, bundle: nil), forCellReuseIdentifier: BoomerThingCollection.cellIdentifier)
        tableView.registerNibFrom(RecommendedPostTableViewCell.self)
        
            tableView.registerNibFrom(PostTableViewCell.self)
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
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            return generateRecommendedCell(tableView, cellForRowAt: indexPath)
        default:
            return generatePostCell(tableView, cellForRowAt: indexPath)
        }
    }
}

extension HomeMainViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = generateHeaderTitle(tableView, viewForHeaderInSection: section)
        
        switch section {
        case 1:
            header?.titleLabel.text = "Meus migos"
        case 2:
            header?.titleLabel.text = "Em Brasília"
        default:
            return nil
            
        }
        
        return header
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 350
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 1, 2:
            return 50
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
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
    
    func generateRecommendedCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RecommendedPostTableViewCell.identifier, for: indexPath)
        
        return cell
    }
    
    func generatePostCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath)
        
        return cell
    }
}

extension HomeMainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let yOffset = scrollView.contentOffset.y + scrollView.contentInset.top
    
        updateNavigationBarAlpha(yOffset)
        updateInformationsCell(yOffset)
        
        //let searchBarConstraintConstant = searchBar.frame.height + scrollView.contentOffset.y
        
       // searchBarTopConstraint?.constant = max(0, -searchBarConstraintConstant)
        
    }
    
    func scrollTableViewToTop() {
        tableView.setContentOffset(CGPoint(x: 0, y: -44), animated: true)
    }
    
    
    func updateNavigationBarAlpha(_ yOffset: CGFloat) {
        let navbarAlphaThreshold: CGFloat = 64.0
        
        if yOffset > (tableViewTopInset - navbarAlphaThreshold) {
            
            let alpha = (yOffset - tableViewTopInset + navbarAlphaThreshold)/navbarAlphaThreshold
            
            navigationBarView.backgroundColor = navigationBarView.backgroundColor?.withAlphaComponent(alpha)
        } else {
            navigationBarView.backgroundColor = navigationBarView.backgroundColor?.withAlphaComponent(0.0)
        }
    }
    
    func updateInformationsCell(_ yOffset: CGFloat) {
        
        let informationAlphaThreshold: CGFloat = 20.0
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
    
        if yOffset > 0 {
            let alpha = (yOffset)/informationAlphaThreshold
            cell?.backgroundColor = cell!.backgroundColor?.withAlphaComponent(alpha)
        } else {
            cell?.backgroundColor = cell!.backgroundColor?.withAlphaComponent(0.0)
        }
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


