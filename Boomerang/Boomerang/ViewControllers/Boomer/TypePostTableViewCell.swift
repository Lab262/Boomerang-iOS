//
//  TypePostTableViewCell.swift
//  Boomerang
//
//  Created by Felipe perius on 22/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class TypePostTableViewCell: UITableViewCell {
    static var cellIdentifier = "typePostCell"
    

    @IBOutlet weak var titlePost: UILabel!
    @IBOutlet weak var imagePost: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
