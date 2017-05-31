//
//  MorePostTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 18/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class MorePostTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return "moreCell"
    }
    
    static var cellHeight: CGFloat {
        return 308.0
    }
    
    static var nibName: String {
        return "MorePostTableViewCell"
    }
    
    @IBOutlet weak var containerIconView: UIView!
    @IBOutlet weak var containerCellView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postIconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var likeAmountLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var commentAmount: UILabel!
    @IBOutlet weak var sharedAmount: UILabel!
    
    @IBOutlet weak var heightPostIconConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var widthPostIconConstraint: NSLayoutConstraint!
   
    var presenter: PostPresenter = PostPresenter()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerIconView.roundCorners(corners: [.bottomLeft], radius: 100.0)
    }
    
    func setupCell(){
        descriptionLabel.text = presenter.post.content
        nameLabel.text = presenter.post.author!.fullName
        presenter.getIconPost(iconImage: postIconImage, height: heightPostIconConstraint, width: widthPostIconConstraint)
        userImage.getUserImage(profile: presenter.post.author!) { (success, msg) in
        }
        hourLabel.text = presenter.post.createdAt!.timeSinceNow()
        
        
        presenter.getCountPhotos()
        presenter.getCoverOfPost { (success, msg, image) in
            if success {
                self.coverImage.image = image!
            } else {
                print ("FAIL COVER POST")
            }
        }
    }

    
    
}
