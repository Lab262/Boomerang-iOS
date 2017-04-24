//
//  NotificationTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 23/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    static var identifier: String {
        return "notificationCell"
    }
    
    static var cellHeight: CGFloat {
        return 70.0
    }
    
    static var nibName: String {
        return "NotificationTableViewCell"
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
