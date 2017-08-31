//
//  ActionsPostTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 22/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class ActionsPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var waitingListButton: UIButton!
    @IBOutlet weak var recommendButton: UIButton!
    
    
    static var identifier: String {
        return "actionsPostCell"
    }
    
    static var cellHeight: CGFloat {
        return 75.0
    }
    
    static var nibName: String {
        return "ActionsPostTableViewCell"
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        waitingListButton.titleLabel?.setDynamicFont()
        recommendButton.titleLabel?.setDynamicFont()
    }
}

