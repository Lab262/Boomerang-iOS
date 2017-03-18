//
//  PageControlCollectionViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 17/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class PageControlCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pageView: UIView!
    
    @IBOutlet weak var heightPageConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var widthPageConstraint: NSLayoutConstraint!
    
    static var identifier: String {
        return "pageControlCell"
    }
    
    static var cellHeight: CGFloat {
        return 168.0
    }
    
    static var nibName: String {
        return "PageControlCollectionViewCell"
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
