//
//  SearchFriendsTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 24/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class SearchFriendsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backgroundSupportView: UIView!
    
    static var identifier: String {
        return "searchFriendsCell"
    }
    
    static var cellHeight: CGFloat {
        return 65.0
    }
    
    static var nibName: String {
        return "SearchFriendsTableViewCell"
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        followButton.layer.cornerRadius = followButton.frame.height/2
        containerView.layer.cornerRadius = 4
        
    }
    
    @IBAction func followAction(_ sender: Any) {
        
    }
    
    
    
}
