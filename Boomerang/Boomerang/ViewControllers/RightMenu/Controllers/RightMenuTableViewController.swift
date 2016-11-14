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
            cell.cellImage = #imageLiteral(resourceName: "profile_dummy")
            cell.imageBigSizeConstraint.isActive = true
            cell.imageSmallSizeConstraint.isActive = false
            return cell
        case rightMenuOptions.addFriends.rawValue:
            cell.cellImage = #imageLiteral(resourceName: "ic_add_friends")
            return cell
        case rightMenuOptions.messages.rawValue:
            cell.cellImage = #imageLiteral(resourceName: "ic_chat")
            return cell
        case rightMenuOptions.notifications.rawValue:
            cell.cellImage = #imageLiteral(resourceName: "ic_notification")
            return cell
        case rightMenuOptions.lovedTricks.rawValue:
            cell.cellImage = #imageLiteral(resourceName: "ic_loved")
            return cell
        case rightMenuOptions.myTricks.rawValue:
            cell.cellImage = #imageLiteral(resourceName: "ic_my_things")
            return cell
        case rightMenuOptions.logout.rawValue:
            cell.cellImage = #imageLiteral(resourceName: "ic_exit")
            cell.backgroundCircleView.backgroundColor = .clear
            return cell

        default:
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let optionRowHeight = CGFloat(75)
        
        if indexPath.row != rightMenuOptions.logout.rawValue {
            return optionRowHeight
        } else {
            let viewHeight = self.view.frame.height
            let numberOfOptionsExcludingLogout = (rightMenuOptions.count - 1)
            let optionsContainerSize = (optionRowHeight * CGFloat(numberOfOptionsExcludingLogout) )
            let headerHeight = CGFloat(25)
            let lastRowSize = viewHeight - optionsContainerSize - headerHeight
            return lastRowSize
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoardToShow = UIStoryboard(name: "RightMenu", bundle: nil)
        
        var viewControllerToShow: UIViewController! = storyBoardToShow.instantiateViewController(withIdentifier: "NotificationsMainViewController")

        switch indexPath.row {
        case rightMenuOptions.profile.rawValue:
            break
        case rightMenuOptions.addFriends.rawValue:
            viewControllerToShow = storyBoardToShow.instantiateViewController(withIdentifier: "AddBoomerMainViewController")
            break
        case rightMenuOptions.messages.rawValue:
            viewControllerToShow = storyBoardToShow.instantiateViewController(withIdentifier: "MessagesMainViewController")
            break
        case rightMenuOptions.notifications.rawValue:
            viewControllerToShow = storyBoardToShow.instantiateViewController(withIdentifier: "NotificationsMainViewController")
            break
        case rightMenuOptions.lovedTricks.rawValue:
            break
        case rightMenuOptions.myTricks.rawValue:
            let storyBoardToShow = UIStoryboard(name: "MyThings", bundle: nil)
            viewControllerToShow = storyBoardToShow.instantiateInitialViewController()
            break
        case rightMenuOptions.logout.rawValue:
            let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
            let vcToShow = storyboard.instantiateInitialViewController()
            self.present(vcToShow!, animated: true, completion: nil)
            DefaultsHelper.sharedInstance.email = ""
            return
            
        default:
            viewControllerToShow = storyBoardToShow.instantiateViewController(withIdentifier: "NotificationsMainViewController")
        }
        
        self.show(viewControllerToShow, sender: self)
        self.navigationController?.isNavigationBarHidden = false
 
    }
    
}
