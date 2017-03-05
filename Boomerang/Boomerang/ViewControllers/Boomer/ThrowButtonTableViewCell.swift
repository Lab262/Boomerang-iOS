//
//  ThrowButtonTableViewCell.swift
//  Boomerang
//
//  Created by Felipe perius on 02/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class ThrowButtonTableViewCell: UITableViewCell {
    static var cellIdentifier = "throwButtonCell"
    
    @IBOutlet weak var throwButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
