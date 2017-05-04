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
    
    var alreadyUpdateCell = false
    
    @IBOutlet weak var button: UIButton!
    
    
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
    
    var inputConfigurationButtons = [(deselectedImage: #imageLiteral(resourceName: "inventory_all_icon_unselected"), selectedImage: #imageLiteral(resourceName: "inventory_all_icon_selected")), (deselectedImage: #imageLiteral(resourceName: "inventory_need_icon_unselected"), selectedImage: #imageLiteral(resourceName: "inventory_need_icon_selected")), (deselectedImage: #imageLiteral(resourceName: "inventory_have_icon_unselected"), selectedImage: #imageLiteral(resourceName: "inventory_have_icon_selected")), (deselectedImage: #imageLiteral(resourceName: "inventory_donation_icon_unselected"), selectedImage: #imageLiteral(resourceName: "inventory_donation_icon_selected"))]
    
    
    var presenter: ProfilePresenter!
    var delegate: UpdateCellDelegate?
    
    override func awakeFromNib() {
        button.layer.cornerRadius = 20
        configureButtons()
    }
    
    func configureButtonAction() {
        if presenter.authorPostIsCurrent() {
            button.setTitle("Editar", for: .normal)
        } else {
            presenter.alreadyFollowing(completionHandler: { (success, msg, alreadyFollowing) in
                if success {
                    if alreadyFollowing! {
                        self.button.setTitle("Unfollow", for: .normal)
                    } else {
                        self.button.setTitle("Follow", for: .normal)
                    }
                    
                }
            })
        }
    }
    
    func configureButtons(){
        let buttons = [filterAllButton, filterNeedButton, filterHaveButton, filterDonationButton]
        for (i, button) in buttons.enumerated() {
            button?.setImage(inputConfigurationButtons[i].deselectedImage, for: .normal)
            button?.setImage(inputConfigurationButtons[i].selectedImage, for: .selected)
        }
        
        buttons[0]?.isSelected = true
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        if button.currentTitle == "Unfollow" {
            presenter.unfollowUser(completionHandler: { (success, msg) in
                if success {
                    self.button.setTitle("Follow", for: .normal)
                    let currentCount = Int(self.followersLabel.text!)
                    self.followersLabel.text = String(currentCount!-1)
                } else {
                    print ("unfollow error")
                }
            })
        } else if button.currentTitle == "Follow" {
            presenter.followUser(completionHandler: { (success, msg) in
                if success {
                    self.button.setTitle("Unfollow", for: .normal)
                    let currentCount = Int(self.followersLabel.text!)
                    self.followersLabel.text = String(currentCount!+1)
                } else {
                    print ("follow error")
                }
            })
        }
    }
    
    
    func updateCell(){
        if !alreadyUpdateCell {
            alreadyUpdateCell = true
            self.nameLabel.text = presenter.getProfile().fullName
            
            if presenter.getProfile().profileImage == nil {
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
            configureButtonAction()
            
            if presenter.authorPostIsCurrent() {
                button.setTitle("Editar", for: .normal)
            } else {
                button.setTitle("Seguir", for: .normal)
            }
        }
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
                self.delegate?.unload()
            } else {
                print ("ERROR COUNT SCHEME")
            }
        }
    }
    
    @IBAction func filterForAllPosts(_ sender: Any) {
        if presenter.getCurrentPostType() != nil {
            presenter.setCurrentPostType(postType: nil)
            filterAllButton.isSelected = true
            filterNeedButton.isSelected = false
            filterHaveButton.isSelected = false
            filterDonationButton.isSelected = false
            delegate?.updateCell()
        }
    }
    
    
    @IBAction func filterForNeedPosts(_ sender: Any) {
        if presenter.getCurrentPostType() != .need {
            presenter.setCurrentPostType(postType: .need)
            filterAllButton.isSelected = false
            filterNeedButton.isSelected = true
            filterHaveButton.isSelected = false
            filterDonationButton.isSelected = false
            delegate?.updateCell()
        }
    }
    
    @IBAction func filterForHavePosts(_ sender: Any) {
        if presenter.getCurrentPostType() != .have {
            presenter.setCurrentPostType(postType: .have)
            filterAllButton.isSelected = false
            filterNeedButton.isSelected = false
            filterHaveButton.isSelected = true
            filterDonationButton.isSelected = false
            delegate?.updateCell()
        }
    }
    
    @IBAction func filterForDonationPosts(_ sender: Any) {
        if presenter.getCurrentPostType() != .donate {
            presenter.setCurrentPostType(postType: .donate)
            filterAllButton.isSelected = false
            filterNeedButton.isSelected = false
            filterHaveButton.isSelected = false
            filterDonationButton.isSelected = true
            delegate?.updateCell()
        }
        
    }
}

