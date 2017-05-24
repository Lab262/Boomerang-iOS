//
//  SeeMoreCollectionViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 23/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class SeeMoreCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return "seeMoreCollectionCell"
    }
    
    static var cellSize: CGSize {
        return  CGSize(width: 366, height: 306)
    }
    
    static var nibName: String {
        return "SeeMoreCollectionViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
