//
//  PhotoThingWithPageControlCollectionViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 20/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class PhotoThingWithPageControlCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thingImage: UIImageView!
    
    static var identifier: String {
        return "photoThingControlCell"
    }
    
    static var cellHeight: CGFloat {
        return 168.0
    }
    
    static var nibName: String {
        return "PhotoThingWithPageControlCollectionViewCell"
    }
    
    var post: Post? {
        didSet{
            updateCellUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCellUI(){
        
    }
}

