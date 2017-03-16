//
//  PostCollectionViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 16/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return "postCollectionCell"
    }
    
    static var cellHeight: CGFloat {
        return 168.0
    }
    
    static var nibName: String {
        return "PostCollectionViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
