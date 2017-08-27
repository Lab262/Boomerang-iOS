//
//  TextFieldGroupTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 22/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit


class TextFieldGroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commentButton: UIButton!
    
    
    static var identifier: String {
        return "textFieldCell"
    }
    
    static var cellHeight: CGFloat {
        return 75.0
    }
    
    static var nibName: String {
        return "TextFieldGroupTableViewCell"
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentButton.titleLabel?.setDynamicFont()
    }

}
