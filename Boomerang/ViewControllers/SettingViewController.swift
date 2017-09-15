//
//  SettingViewController.swift
//  Boomerang
//
//  Created by Felipe perius on 27/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse
class SettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tableViewLeftInset: CGFloat = 15
    var tableViewRightInset: CGFloat = 15
    let tableViewBottomInset = CGFloat(80.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
        tableView.contentInset = UIEdgeInsetsMake(0, 0, tableViewBottomInset, 0)
        
    }
    
    
    func registerNib(){
        tableView.registerNibFrom(NotificationSwitchTableViewCell.self)
          tableView.registerNibFrom(DistanceRadiusTableViewCell.self)
                  tableView.registerNibFrom(LogOutTableViewCell.self)
    }
    
    
    func singout(_ sender: UIButton) {
        self.showAlertLogout()
    }

    func disconect(){
        var initialViewController: UIViewController? = nil
        
        //TODO: Verify rules of show onboard main
        UserDefaults.standard.set(nil, forKey: OnboardKeyLogin.keyLoginFirstTime)
        
        PFUser.logOut()
        
        initialViewController = ViewUtil.viewControllerFromStoryboardWithIdentifier("Authentication", identifier: "AuthenticationMainViewController")
        
        self.present(initialViewController!, animated:true, completion:nil)
    }
    
    
    func showAlertLogout(){
        GenericBoomerAlertController.presentMe(inParent: self, withTitle: "Você deseja mesmo sair?", positiveAction: "Sair", negativeAction: "Cancelar") { (isPositive) in
            if isPositive {
                self.disconect()
            }
        }
    }
    
    func generateNotificationCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationSwitchTableViewCell.identifier, for: indexPath) as! NotificationSwitchTableViewCell
       
        return cell
    }

    func generateDistanceRadiusCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DistanceRadiusTableViewCell.identifier, for: indexPath) as! DistanceRadiusTableViewCell
        
        return cell
    }

    func generateLogoutCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LogOutTableViewCell.identifier, for: indexPath) as! LogOutTableViewCell
        
        cell.logoutButton.addTarget(self, action: #selector(singout(_:)), for: .touchUpInside)
        
        
        return cell
    }
}

extension SettingViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
      
        case 0:
            
           return generateNotificationCell(tableView, cellForRowAt: indexPath)
        case 1:
            return generateDistanceRadiusCell(tableView, cellForRowAt: indexPath)
        case 2:
            return generateLogoutCell(tableView, cellForRowAt: indexPath)
            default:
                return  UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
  
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        switch indexPath.row {
            
        case 0:
            return NotificationSwitchTableViewCell.cellHeight * UIView.heightScaleProportion()
        case 1:
            return DistanceRadiusTableViewCell.cellHeight * UIView.heightScaleProportion()
        case 2:
            return LogOutTableViewCell.cellHeight * UIView.heightScaleProportion()
        default:
            return  10
        }
     
        
    }
 
}

