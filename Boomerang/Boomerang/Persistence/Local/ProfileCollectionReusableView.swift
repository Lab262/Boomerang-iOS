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
    
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var boomerAmountLabel: UILabel!
    
    
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
        
        getAmountInformations()
    }
    
    func getAmountInformations(){
        
        presenter.getUserCountOf(key: "to", className: "Follow") { (success, msg, count) in
            if success {
                self.followersLabel.text = count?.description
            } else {
                print ("ERROR COUNT FOLLOWERS")
            }
        }
        
        presenter.getUserCountOf(key: "from", className: "Follow") { (success, msg, count) in
            if success {
                self.followingLabel.text = count?.description
            } else {
                print ("ERROR COUNT FOLLOWING")
            }
        }
        
        presenter.getUserCountOf(key: "from", className: "Scheme") { (success, msg, count) in
            if success {
                
                var text: String?
                
                if count == 0 {
                    text = "Nenhum arremesso."
                } else if count == 1 {
                    text = "\(String(describing: count)) arremesso."
                } else {
                    text = "\(String(describing: count)) arremessos."
                }
                self.boomerAmountLabel.text = text
            } else {
                print ("ERROR COUNT SCHEME")
            }
        }
    }
    
    @IBAction func filterForAllPosts(_ sender: Any) {
        if presenter.getCurrentPostType() != nil {
            presenter.setCurrentPostType(postType: nil)
            delegate?.updateCell()
        }
    }
    
    
    @IBAction func filterForNeedPosts(_ sender: Any) {
        if presenter.getCurrentPostType() != .need {
            presenter.setCurrentPostType(postType: .need)
            delegate?.updateCell()
        }
    }
    
    @IBAction func filterForHavePosts(_ sender: Any) {
        if presenter.getCurrentPostType() != .have {
            presenter.setCurrentPostType(postType: .have)
            delegate?.updateCell()
        }
    }
    
    @IBAction func filterForDonationPosts(_ sender: Any) {
        if presenter.getCurrentPostType() != .donate {
            presenter.setCurrentPostType(postType: .donate)
            delegate?.updateCell()
        }
    }
}

