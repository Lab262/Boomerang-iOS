//
//  TypePostTableViewCell.swift
//  Boomerang
//
//  Created by Felipe perius on 22/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class TypePostTableViewCell: UITableViewCell {

    @IBOutlet weak var titlePost: UILabel!
    @IBOutlet weak var imagePost: UIImageView!
    
    static var identifier: String {
        return "typePostCell"
    }
    
    static var nibName: String {
        return "TypePostTableViewCell"
    }
    
    var titlePostString: String? {
        didSet{
            let title = titlePostString?.with(characterSpacing: 2, color:titlePost.textColor)
            titlePost.attributedText = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titlePost.setDynamicFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
