//
//  SettingViewController.swift
//  Boomerang
//
//  Created by Felipe perius on 27/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let tableViewTopInset: CGFloat = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
    }
    
    
    func registerNib(){
        tableView.registerNibFrom(NotificationSwitchTableViewCell.self)
    }
    
    func generateTitleCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "titleSettingCell", for: indexPath)
        return cell
        
    }

    func generateNotificationCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationSwitchTableViewCell.identifier, for: indexPath) as! NotificationSwitchTableViewCell
       
        return cell
    }
}

extension SettingViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
           
            return generateTitleCell(tableView, cellForRowAt: indexPath)
        case 1:
            
           return generateNotificationCell(tableView, cellForRowAt: indexPath)
        default:
            return  UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
  
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 25.0
        default:
            return NotificationSwitchTableViewCell.cellHeight * UIView.heightScaleProportion()
        }
    }
 
}

