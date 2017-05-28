//
//  LogOutTableViewCell.swift
//  Boomerang
//
//  Created by Felipe perius on 27/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class LogOutTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return "logOutCell"
    }
    
    @IBOutlet weak var logoutButton: UIButton!
    static var cellHeight: CGFloat {
        return 45
    }
    
    static var nibName: String {
        return "LogOutTableViewCell"
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
