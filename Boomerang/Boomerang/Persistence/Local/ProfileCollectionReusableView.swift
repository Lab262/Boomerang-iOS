//
//  ProfileCollectionReusableView.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class ProfileCollectionReusableView: UICollectionReusableView {
    
    static var identifier: String {
        return "ProfileHeaderView"
    }
    
    @IBOutlet weak var filterAllButton: UIButton!
    @IBOutlet weak var filterHaveButton: UIButton!
    @IBOutlet weak var filterNeedButton: UIButton!
    @IBOutlet weak var filterDonationButton: UIButton!
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var cityAndUFLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var presenter: ProfilePresenter!
    var delegate: UpdateCellDelegate?
    
    func updateCell(){
        self.nameLabel.text = presenter.getUser().fullName
        
        if presenter.getUser().profileImage == nil {
            profileImage.loadAnimation()
        }
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
        presenter.setCurrentPostType(postType: nil)
        delegate?.updateCell()
    }
    
    
    @IBAction func filterForNeedPosts(_ sender: Any) {
        presenter.setCurrentPostType(postType: .need)
        delegate?.updateCell()
    }
    
    @IBAction func filterForHavePosts(_ sender: Any) {
        presenter.setCurrentPostType(postType: .have)
        delegate?.updateCell()
    }
    
    @IBAction func filterForDonationPosts(_ sender: Any) {
        presenter.setCurrentPostType(postType: .donate)
        delegate?.updateCell()
    }
}

