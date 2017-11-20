//
//  PostPhotoCollectionViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 25/10/2017.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class PostPhotoCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return "postPhotoCell"
    }
    
    static var cellSize: CGSize {
        return CGSize(width: 200, height: 185)
    }
    
    static var nibName: String {
        return "PostPhotoCollectionViewCell"
    }

    @IBOutlet weak var postPhoto: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
}
