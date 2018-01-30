//
//  EmptyFriendsCollectionViewCell.swift
//  Boomerang
//
//  Created by Luís Resende on 22/09/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class EmptyFriendsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImageView: UIView!
    static var identifier: String {
        return "emptyFriendsCollectionViewCell"
    }
    
    static var cellSize: CGSize {
        return  CGSize(width: 270, height: 228)
    }
    
    static var nibName: String {
        return "EmptyFriendsCollectionViewCell"
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.setDynamicFont()
        //self.messageLabel.setDynamicFont()
    }

}
