//
//  ProfileCollectionReusableView.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class ProfileCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var cityAndUFLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var user: User? {
        didSet{
           self.updateUI()
        }
    }
    
    
    override func awakeFromNib() {
        
    }
    
    func updateUI(){
        self.getUserPhoto()
        self.nameLabel.text = user!.firstName! + " " + user!.lastName!
    }
    
    func getUserPhoto() {
        
        guard let image = user?.profileImage else {
            
            profileImage.loadAnimation()
            
//            UserRequest.getProfilePhoto(user: user!, completionHandler: { (success, msg, photo) in
//                
//                if success {
//                    self.user?.profileImage = photo
//                    self.profileImage.image = photo
//                    self.profileImage.unload()
//                } else {
//                    // error
//                }
//            })
            
            return
        }
        
        self.profileImage.image = image
    }
    
}
