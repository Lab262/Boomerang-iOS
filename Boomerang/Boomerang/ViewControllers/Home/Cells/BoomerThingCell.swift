//
//  BoomerThingCell.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 07/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import Parse

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
        self.thingDescriptionLabel.text = thingData.post?.content
        self.profileNameLabel.text = thingData.post!.author!.firstName! + " " + thingData.post!.author!.lastName!
        
        self.getUserPhotoImage()
        self.getRelationPhotosByThing()
    }
    
    
    func getUserPhotoImage() {
        guard let image = thingData.post?.author?.profileImage else {
            profilePhotoImgView.loadAnimation()
            
            thingData.post?.author?.getDataInBackgroundBy(key: #keyPath(User.imageFile), completionHandler: { (success, msg, data) in
                
                if success {
                    self.thingData.post?.author?.profileImage = UIImage(data: data!)
                    self.profilePhotoImgView.image = UIImage(data: data!)
                    self.profilePhotoImgView.unload()
                } else {
                    // error
                }
            })
            
            return
        }
        profilePhotoImgView.image = image
    }

    func getRelationPhotosByThing(){
        
        if thingData.post!.photos.count > 0 {
            
            imgViewThingPhoto.image = thingData.post?.photos[0]
            
        } else {
            
            thingData.post?.getRelationsInBackgroundWithDataBy(key: "photos", keyFile: "imageFile", completionHandler: { (success, msg, objects, data) in
                
                if success {
                    self.thingData.post?.photos.append(UIImage(data: data!)!)
                    self.imgViewThingPhoto.image = UIImage(data: data!)!
                    self.imgViewThingPhoto.unload()
                } else {
                    
                }
            })
        }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.window?.endEditing(true)
    }
    
}
