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
    
    var presenter: ProfilePresenter = ProfilePresenter()
    
    override func awakeFromNib() {
        updateCell()
    }
    
    func updateCell(){
        self.nameLabel.text = presenter.getUser().fullName
        profileImage.loadAnimation()
        presenter.getUserImage { (success, msg, image) in
            if success {
                self.profileImage.image = image
                self.profileImage.unload()
            } else {
                print ("ERROR DOWNLOAD IMAGE")
            }
        }
    }
}
