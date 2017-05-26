//
//  SimpleTextFieldTableViewCell.swift
//  Boomerang
//
//  Created by Felipe perius on 02/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit


class SimpleTextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    var handler: TextFieldHandler?
    
    static var identifier: String {
        return "simpleTextCell"
    }
    
    static var nibName: String {
        return "SimpleTextFieldTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.setDynamicFont()
        self.textField.font = UIFont(name: (self.textField.font?.fontName)!, size: (self.textField.font?.pointSize)!*UIView.widthScaleProportion())!
        self.handler = TextFieldHandler(_textField: textField)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
