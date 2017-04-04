//
//  ProfileCollectionReusableView.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class ProfileCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var filterAllButton: UIButton!
    @IBOutlet weak var filterHaveButton: UIButton!
    @IBOutlet weak var filterNeedButton: UIButton!
    @IBOutlet weak var filterDonationButton: UIButton!
    
    
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
    
    @IBAction func filterForAllPosts(_ sender: Any) {
        
    }
    
    
    @IBAction func filterForNeedPosts(_ sender: Any) {
        
    }
    
    @IBAction func filterForHavePosts(_ sender: Any) {
        
    }
    
    @IBAction func filterForDonationPosts(_ sender: Any) {
        
    }
    
    
    
    
}
