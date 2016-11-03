//
//  RightMenuTableViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 03/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

enum rightMenuOptions: Int {
    case profile,
    addFriends,
    messages,
    notifications,
    lovedTricks,
    myTricks,
    logout
    static var count: Int { return rightMenuOptions.logout.rawValue + 1}
}

class RightMenuTableViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    var mainViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}


extension RightMenuTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rightMenuOptions.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RightMenuCell", for: indexPath) as! RightMenuCell
        
        switch indexPath.row {
        case rightMenuOptions.profile.rawValue:
            cell.cellImage = UIImage(named: "ic_tabbar_boomer")
            return cell
        case rightMenuOptions.addFriends.rawValue:
            cell.cellImage = UIImage(named: "ic_tabbar_boomer")
            return cell
        case rightMenuOptions.messages.rawValue:
            cell.cellImage = UIImage(named: "ic_tabbar_boomer")
            return cell
        case rightMenuOptions.notifications.rawValue:
            cell.cellImage = UIImage(named: "ic_tabbar_boomer")
            return cell
        case rightMenuOptions.lovedTricks.rawValue:
            cell.cellImage = UIImage(named: "ic_tabbar_boomer")
            return cell
        case rightMenuOptions.myTricks.rawValue:
            cell.cellImage = UIImage(named: "ic_tabbar_boomer")
            return cell
        case rightMenuOptions.logout.rawValue:
            cell.cellImage = UIImage(named: "ic_tabbar_boomer")
            return cell

        default:
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoardToShow = UIStoryboard(name: "RightMenu", bundle: nil)
        let viewControllerToShow = storyBoardToShow.instantiateViewController(withIdentifier: "DetailView")
        self.show(viewControllerToShow, sender: self)
        self.navigationController?.isNavigationBarHidden = false

        switch indexPath.row {
        case rightMenuOptions.profile.rawValue:
//            cell.cellImage = UIImage(named: "ic_tabbar_boomer")
            break
        case rightMenuOptions.addFriends.rawValue:
//            cell.cellImage = UIImage(named: "ic_tabbar_boomer")
            break
        case rightMenuOptions.messages.rawValue:
//            cell.cellImage = UIImage(named: "ic_tabbar_boomer")
            break
        case rightMenuOptions.notifications.rawValue:
//            cell.cellImage = UIImage(named: "ic_tabbar_boomer")
            break
        case rightMenuOptions.lovedTricks.rawValue:
//            cell.cellImage = UIImage(named: "ic_tabbar_boomer")
            break
        case rightMenuOptions.myTricks.rawValue:
//            cell.cellImage = UIImage(named: "ic_tabbar_boomer")
            break
        case rightMenuOptions.logout.rawValue:
//            cell.cellImage = UIImage(named: "ic_tabbar_boomer")
            break
            
        default:
            return
        }
        
        
        

        
    }
    
}
