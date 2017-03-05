//
//  SimpleTextFieldTableViewCell.swift
//  Boomerang
//
//  Created by Felipe perius on 02/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class SimpleTextFieldTableViewCell: UITableViewCell {
    static var cellIdentifier = "simpleTextCell"
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
