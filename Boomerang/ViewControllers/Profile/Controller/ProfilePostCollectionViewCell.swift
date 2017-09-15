//
//  ProfilePostCollectionViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 04/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class ProfilePostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverPostImage: UIImageView!
    
    static var identifier: String {
        return "postUserCell"
    }
    
    static var cellHeight: CGFloat {
        return 168.0
    }
    
    var presenter: ProfilePresenter = ProfilePresenter()
    
    func updatePostCell(){
      //  presenter.getCountPhotos()
        
        presenter.getCoverOfPost { (success, msg, image) in
            if success {
                self.coverPostImage.image = image!
            } else {
                print ("FAIL COVER POST")
            }
        }
    }
    
}
