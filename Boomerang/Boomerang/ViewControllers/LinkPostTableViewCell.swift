//
//  LinkPostTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 12/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class LinkPostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var showPostButton: UIButton!
    @IBOutlet weak var datePostLabel: UILabel!
    
    
    static var identifier: String {
        return "linkPostCell"
    }
    
    static var cellHeight: CGFloat {
        return 76.0
    }
    
    static var nibName: String {
        return "LinkPostTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 9
    }

    @IBAction func showPost(_ sender: Any) {
        
    }
    
}
