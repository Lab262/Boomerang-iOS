//
//  SearchFriendsTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 24/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import SwipeCellKit

class SearchFriendsTableViewCell: SwipeTableViewCell {
    
    @IBOutlet weak var recomendedIndicatorImageView: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backgroundSupportView: UIView!
    static var identifier: String {
        return "searchFriendsCell"
    }
    
    static var cellHeight: CGFloat {
        return 61.0
    }
    
    static var nibName: String {
        return "SearchFriendsTableViewCell"
    }
    
    var following: Bool? {
        didSet {
            changeFollowButtonStyle()
        }
    }
    
    var profile: Profile? {
        didSet {
            updateCellInformations()
        }
    }
    
    let followButtonHighlightedTitle = "Seguindo"
    let followButtonHighlightedBackgroundColor = UIColor.colorWithHexString("F6A01F")
    let followButtonHighlightedTitleColor = UIColor.white
    let followButtonNormalTitle = "Seguir"
    let followButtonNormalBackgroundColor = UIColor.white
    let followButtonNormalTitleColor = UIColor.black
    var presenter: SearchFriendsCellPresenter = SearchFriendsCellPresenter()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        followButton.layer.cornerRadius = followButton.frame.height/2
        containerView.layer.cornerRadius = 4
        configureDynamicFonts()
        setupViewDelegate()
    }
    
    func setupViewDelegate() {
        presenter.setViewDelegate(view: self)
    }
    
    func configureDynamicFonts(){
        nameLabel.setDynamicFont()
        cityLabel.setDynamicFont()
    }
    
    
    func setupCellInformations(fetchAlreadyFollowing: Bool, isFollowing: Bool? = false) {
        
        if fetchAlreadyFollowing {
            presenter.getIsAlreadyFollwing()
        } else {
            following = isFollowing
        }
        
        nameLabel.text = presenter.profile.fullName
        cityLabel.text = "Brasília - DF"
        userImage.getUserImage(profile: presenter.profile) { (success, msg) in
        }
    }
    
    func updateCellInformations() {
        nameLabel.text = profile?.fullName
        cityLabel.text = "Brasília - DF"
        userImage.getUserImage(profile: profile!) { (success, msg) in
        }
        if profile?.isRecommended ?? false {
            self.recomendedIndicatorImageView.alpha = 1
            self.isUserInteractionEnabled = false
        } else {
            self.recomendedIndicatorImageView.alpha = 0
            self.isUserInteractionEnabled = true
        }
    }
    
    private func setupSelectedFollowButton() {
        self.followButton.backgroundColor = self.followButtonHighlightedBackgroundColor
        self.followButton.setTitleColor(self.followButtonHighlightedTitleColor, for: .normal)
    }
    
    private func setupNormalFollowButton() {
        self.followButton.backgroundColor = self.followButtonNormalBackgroundColor
        self.followButton.setTitleColor(self.followButtonNormalTitleColor, for: .normal)
    }
    
    func changeFollowButtonStyle() {
        let animationDuration = 0.07
        
        if following! {
            UIView.animate(withDuration: animationDuration) {
                self.setupSelectedFollowButton()
            }
            followButton.setTitle(followButtonHighlightedTitle, for: .normal)
        } else {
            UIView.animate(withDuration: animationDuration) {
                self.setupNormalFollowButton()
            }
            followButton.setTitle(followButtonNormalTitle, for: .normal)
        }
        //followButton.bouncingAnimation(duration: 0.4)
    }

    func toggleRecomendedAnimation() {
        self.userImage.bouncingAnimation(duration: 0.25, delay: 0.0)
        self.recomendedIndicatorImageView.bouncingAnimation(duration: 0.25, delay: 0.0)

//        if self.recomendedIndicatorImageView.alpha <= 0 {
//            self.recomendedIndicatorImageView.fadeIn(0.25)
//        } else {
//            self.recomendedIndicatorImageView.fadeOut(0.25)
//        }
    }

    @IBAction func followAction(_ sender: Any) {
        
        if self.following! {
            presenter.followAction(action: .unfollow)
        } else {
            presenter.followAction(action: .follow)
        }
    }
}

extension SearchFriendsTableViewCell: SearchFriendsCellDelegate {

    func showMessage(msg: String) {
        // message error
    }
    
    func buttonActionResult(success: Bool, action: FollowButtonAction) {
        
//        if success {
//            following = !following!
//        }
    }
}
