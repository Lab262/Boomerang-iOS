//
//  HighlightCollectionViewCell.swift
//  OhMyBox
//
//  Created by André Marques da Silva Rodrigues on 28/02/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class HighlightCollectionViewCell: UICollectionViewCell {

    static var identifier: String {
        return "highlightCollectionViewCell"
    }
    
    static var cellSize: CGSize {
        return CGSize(width: 350, height: 337)
    }
    
    static var nibName: String {
        return "HighlightCollectionViewCell"
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpShadow()
    }
    
    func setUpShadow() {
        shadowColor = .black
        shadowRadius = 2.0
        shadowOffset = CGSize(width: 0, height: 2)
    }

}
