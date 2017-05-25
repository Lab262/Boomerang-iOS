//
//  NotificationsMainViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 08/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4
import SwiftyJSON


class AddBoomerMainViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var cellDatas = [BoomerCellData]()
    var friendsArray : [Friend] = []
    var cache = false
    
    func loadDummyData() {
        self.updateUserByFacebook()
    }
    
    func setupSearchBarConfiguration() {
        searchBar.setBackgroundImage(ViewUtil.imageFromColor(.clear, forSize:searchBar.frame.size, withCornerRadius: 0), for: .any, barMetrics: .default)
        searchBar.setBackgroundSearchBarColor(color: UIColor.backgroundSearchColor)
        searchBar.setCursorSearchBarColor(color: UIColor.textSearchColor)
        searchBar.setPlaceholderSearchBarColor(color: UIColor.textSearchColor)
        searchBar.setTextSearchBarColor(color: UIColor.textSearchColor)
        searchBar.setIconSearchBarColor(color: UIColor.textSearchColor)
        searchBar.setClearIconSearchBarColor(color: UIColor.textSearchColor)
    }
    
    func updateUserByFacebook(){
        self.view.loadAnimation()
        let requestParameters = ["fields":"id,name, installed, email,location,picture.width(100).height(100)"]
        let userDetails = FBSDKGraphRequest(graphPath: "/me/friends?fields=installed", parameters: requestParameters)
        userDetails!.start { (connection, result, error) -> Void in
            if error != nil {
                print(error.debugDescription)
                 self.view.unload()
            }else {
               if let data = result as? [String: Any] {
                    if let data = data["data"] as? [[String: Any]] {
                        for userData:[String: Any] in data {
                            if let friend = Friend(JSON: userData) {
                                self.friendsArray.append(friend)
                            }
                        }
                        
                    }
                }
                
            self.updateTableByAppendingUsers()
                self.view.unload()
            }
        }
      
    }
    
    func loadImage(urlImage:String, cell: UITableViewCell, indexPath: IndexPath) {
        
        let requestCell = cell as! SearchFriendsTableViewCell
        
        if let url = URL(string:urlImage) {
                do {
                    let contents = try Data(contentsOf: url)
                    let image = UIImage(data:contents)
                    requestCell.userImage.image = image
                
                }catch {
                    // contents could not be loaded
                }
            } else {
         
            }
    }
    
    
    func updateTableByAppendingUsers(){
        for friend in self.friendsArray{
           let placeHolder = UIImage(named: "placeholder")
           let boomer = BoomerCellData(dataPhoto:placeHolder!, dataDescription:"Brasilia-DF", dataTitle:friend.firstName!)
            cellDatas.append(boomer)
        }
        
        self.tableView.reloadData()
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDummyData()
        self.registerNibs()
        setupSearchBarConfiguration()
    }
    
    func registerNibs() {
        tableView.registerNibFrom(SearchFriendsTableViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.window?.endEditing(true)
    }
}


extension AddBoomerMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchFriendsTableViewCell.identifier, for: indexPath) as! SearchFriendsTableViewCell
        cell.facebookFriend = self.cellDatas[indexPath.row]
        self.loadImage(urlImage: self.friendsArray[indexPath.row].pictureURL!, cell:cell, indexPath: indexPath)
        
        
        return cell
    }

}
