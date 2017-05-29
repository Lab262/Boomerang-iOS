//
//  NotificationSwitchTableViewCell.swift
//  Boomerang
//
//  Created by Felipe perius on 27/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class NotificationSwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var `switch`: UISwitch!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    static var identifier: String {
        return "notificationSwithcCell"
    }
    
    static var cellHeight: CGFloat {
        return 80.0
    }
    
    static var nibName: String {
        return "NotificationSwitchTableViewCell"
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.setDynamicFont()
        descriptionLabel.setDynamicFont()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
