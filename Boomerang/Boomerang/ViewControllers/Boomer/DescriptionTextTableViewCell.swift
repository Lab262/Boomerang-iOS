//
//  DescriptionTextTableViewCell.swift
//  Boomerang
//
//  Created by Felipe perius on 02/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class DescriptionTextTableViewCell: UITableViewCell {
    static var cellIdentifier = "descriptionTextCell"
    var handler: TextViewHandler?

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.setDynamicFont()
        self.textView?.textContainerInset.left = 10;
        self.textView.font = UIFont(name: (self.textView.font?.fontName)!, size: (self.textView.font?.pointSize)!*UIView.widthScaleProportion())!
        self.handler = TextViewHandler(textView: textView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        // Configure the view for the selected state
    }
    
}
