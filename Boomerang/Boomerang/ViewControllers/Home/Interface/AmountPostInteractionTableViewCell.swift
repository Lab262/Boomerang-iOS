//
//  AmountPostInteractionTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 20/08/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class AmountPostInteractionTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return "amountPostCell"
    }
    
    static var cellHeight: CGFloat {
        return 44.0
    }
    
    static var nibName: String {
        return "AmountPostInteractionTableViewCell"
    }

    @IBOutlet weak var likeAmountButton: UIButton!
    
    @IBOutlet weak var commentAmountButton: UIButton!
    
    @IBOutlet weak var recommendationAmountButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
}
