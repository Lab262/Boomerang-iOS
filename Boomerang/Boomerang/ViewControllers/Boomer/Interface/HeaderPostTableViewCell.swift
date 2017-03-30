//
//  HeaderPostTableViewCell.swift
//  Boomerang
//
//  Created by Felipe perius on 25/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class HeaderPostTableViewCell: UITableViewCell {
    static var cellIdentifier = "HeaderPostCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var throwButton: UIButton!
    @IBOutlet weak var photo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
