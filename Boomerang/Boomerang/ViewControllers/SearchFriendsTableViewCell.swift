//
//  SearchFriendsTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 24/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class SearchFriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backgroundSupportView: UIView!
    

    var presenter: SearchFriendsCellPresenter = SearchFriendsCellPresenter()
    
    static var identifier: String {
        return "searchFriendsCell"
    }
    
    static var cellHeight: CGFloat {
        return 65.0
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        following = false
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
    
    
    func setupCellInformations() {
        presenter.getIsAlreadyFollwing()
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
    }
    
    func changeFollowButtonStyle() {
        let animationDuration = 0.07
        
        if following! {
            UIView.animate(withDuration: animationDuration) {
                self.followButton.backgroundColor = self.followButtonHighlightedBackgroundColor
                self.followButton.setTitleColor(self.followButtonHighlightedTitleColor, for: .normal)
            }
            followButton.setTitle(followButtonHighlightedTitle, for: .normal)
        } else {
            UIView.animate(withDuration: animationDuration) {
                self.followButton.backgroundColor = self.followButtonNormalBackgroundColor
                self.followButton.setTitleColor(self.followButtonNormalTitleColor, for: .normal)
            }
            followButton.setTitle(followButtonNormalTitle, for: .normal)
        }
        //followButton.bouncingAnimation(duration: 0.4)
    }
    
    @IBAction func followAction(_ sender: Any) {
        let action: FollowButtonAction = following! ? .follow : .unfollow
        
        
        presenter.followAction(action: action)
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
