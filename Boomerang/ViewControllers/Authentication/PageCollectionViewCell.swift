//
//  PageCollectionViewCell.swift
//  Boomerang
//
//  Created by Felipe perius on 09/09/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class PageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imagePageView: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    
    static var identifier: String {
        return "pageCollectionViewCell"
    }
    
    static var cellSize: CGSize {
        return CGSize(width: 375, height: 227)
    }
    
    static var nibName: String {
        return "PageCollectionViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
