//
//  MoreCommentTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class MoreCommentTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return "moreCell"
    }
    
    static var cellHeight: CGFloat {
        return 50.0
    }
    
    static var nibName: String {
        return "MoreCommentTableViewCell"
    }
    
    @IBOutlet weak var moreButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        moreButton.titleLabel?.setDynamicFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
