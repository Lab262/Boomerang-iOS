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
    
    var titlePostString: String? {
        didSet{
            let title = titlePostString?.with(characterSpacing: 2, color:titlePost.textColor)
            titlePost.attributedText = title
        }
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
