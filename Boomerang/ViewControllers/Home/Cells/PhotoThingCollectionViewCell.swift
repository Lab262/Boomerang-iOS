//
//  PhotoThingWithPageControlCollectionViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 20/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class PhotoThingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thingImage: UIImageView!
    

    static var identifier: String {
        return "photoThingCell"
    }
    
    static var cellSize: CGSize {
        return CGSize(width: 375, height: 290)
    }
    
    
    static var nibName: String {
        return "PhotoThingCollectionViewCell"
    }
    
    var post: Post? {
        didSet{
            updateCellUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        print(#function, "corner: \(self.thingImage.cornerRadius)")
        // Initialization code
    }
    
    func updateCellUI(){
        
    }
}

