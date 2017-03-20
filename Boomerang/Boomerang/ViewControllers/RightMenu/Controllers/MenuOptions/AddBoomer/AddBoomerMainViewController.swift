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
    
    var cellDatas = [BoomerCellData]()
    var friendsArray : [Friend] = []
    var cache = false
    
    func loadDummyData() {
        self.updateUserByFacebook()
    }
    
    
    func updateUserByFacebook(){
        
        self.view.loadAnimation()
        let requestParameters = ["fields":"id,name,email,location,picture.width(100).height(100)"]
        let userDetails = FBSDKGraphRequest(graphPath: "/me/taggable_friends?limit=8", parameters: requestParameters)
        
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
        
        let requestCell = cell as! AddBoomerCell
        
        if let url = URL(string:urlImage) {
                do {
                    let contents = try Data(contentsOf: url)
                    let image = UIImage(data:contents)
                    requestCell.photoImageView.image = image
                
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
    }
    
    func registerNibs() {
        let nib = UINib(nibName: AddBoomerCell.cellIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: AddBoomerCell.cellIdentifier)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: AddBoomerCell.cellIdentifier, for: indexPath) as! AddBoomerCell
        cell.boomerCellData = self.cellDatas[indexPath.row]
        
        self.loadImage(urlImage: self.friendsArray[indexPath.row].pictureURL!, cell:cell, indexPath: indexPath)
        
        
        return cell
    }

}
