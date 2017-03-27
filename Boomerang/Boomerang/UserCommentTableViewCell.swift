//
//  UserCommentTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 25/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class UserCommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userPhotoImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var comment: Comment? {
        didSet{
            updateCellUI()
        }
    }
    
    
    static var identifier: String {
        return "commentCell"
    }
    
    static var cellHeight: CGFloat {
        return 254.0
    }
    
    static var nibName: String {
        return "UserCommentTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCellUI(){
        userNameLabel.text = comment!.author!.name
        userDescriptionLabel.text = comment!.content
    }
}
