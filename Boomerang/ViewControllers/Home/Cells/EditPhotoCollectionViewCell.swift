//
//  EditPhotoCollectionViewCell.swift
//  Boomerang
//
//  Created by Felipe perius on 26/08/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class EditPhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    static var identifier: String {
        return "editPhotoCollectionViewCell"
    }
    static var nibName: String {
        return "EditPhotoCollectionViewCell"
    }
    
    var image: UIImage? {
        didSet {
            setupCell()
        }
    }

    func setupCell(){
        self.imageView.image = self.image
    }
}
