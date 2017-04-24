//
//  NotificationViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 23/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableViewLeftInset: CGFloat = 15
    var tableViewRightInset: CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        configureTableView()
    }

    func registerNib(){
        tableView.registerNibFrom(NotificationTableViewCell.self)
    }
    
    func configureTableView(){
       // tableView.contentInset = UIEdgeInsetsMake(0, tableViewLeftInset, 0, tableViewRightInset)
    }
}

extension NotificationViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identifier, for: indexPath) as! NotificationTableViewCell
        
        if indexPath.row == 1 {
            cell.backgroundSupportView.isHidden = true
        } else {
            cell.backgroundSupportView.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
}

extension NotificationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return NotificationTableViewCell.cellHeight * UIView.heightScaleProportion()
    }
}

