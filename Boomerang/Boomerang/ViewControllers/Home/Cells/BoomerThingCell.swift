//
//  BoomerThingCell.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 07/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class BoomerThingCell: UICollectionViewCell {

    static let cellIdentifier = "BoomerThingCell"
    @IBOutlet weak var imgViewThingPhoto: UIImageView!
    @IBOutlet weak var profilePhotoImgView: UIImageView!
    @IBOutlet weak var profilePhotoImgView0: UIImageView!
    @IBOutlet weak var profilePhotoImgView2: UIImageView!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var thingDescriptionLabel: UILabel!
    @IBOutlet weak var profilePhotosConstraint: NSLayoutConstraint!
    @IBOutlet weak var profilePhotosConstaintExperience: NSLayoutConstraint!
    
 
    var thingData: BoomerThing! {
        didSet {
            setupCell()
        }
    }
    
    func setupCell() {
        
        self.imgViewThingPhoto.image = thingData.thingPhoto
        self.thingDescriptionLabel.text = thingData.thingDescription
        self.profilePhotoImgView.image = thingData.profilePhoto
        self.profileNameLabel.text = thingData.profileName
        
    }

    func setupProfilePhotoData() {
        
        if thingData.thingType != .experience {
            self.profilePhotoImgView0.isHidden = true
            self.profilePhotoImgView2.isHidden = true
            self.profilePhotosConstraint.isActive = true
            self.profilePhotosConstaintExperience.isActive = false
            
        } else {
            
            self.profilePhotoImgView0.isHidden = false
            self.profilePhotoImgView2.isHidden = false
            self.profilePhotosConstraint.isActive = false
            self.profilePhotosConstaintExperience.isActive = true
            
        }
        
    }
    
    
    override func draw(_ rect: CGRect) {
        self.setupProfilePhotoData()
        
        self.profilePhotoImgView.layer.cornerRadius = self.profilePhotoImgView.frame.height / 2
        self.profilePhotoImgView.layer.masksToBounds = true
        self.profilePhotoImgView0.layer.cornerRadius = self.profilePhotoImgView0.frame.height / 2
        self.profilePhotoImgView0.layer.masksToBounds = true
        self.profilePhotoImgView2.layer.cornerRadius = self.profilePhotoImgView2.frame.height / 2
        self.profilePhotoImgView2.layer.masksToBounds = true
        
    }
    
}
