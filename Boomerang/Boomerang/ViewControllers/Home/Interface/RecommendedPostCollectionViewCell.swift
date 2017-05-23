//
//  RecommendedPostCollectionViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 15/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class RecommendedPostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerCellView: UIView!
    @IBOutlet weak var containerIconView: UIView!
    @IBOutlet weak var typePostImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionPostLabel: UILabel!
    @IBOutlet weak var commentAmountLabel: UILabel!
    @IBOutlet weak var likeAmountLabel: UILabel!
    @IBOutlet weak var sharedAmountLabel: UILabel!
    @IBOutlet weak var heightPostIconConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthPostIconConstraint: NSLayoutConstraint!
    
    
    var presenter: PostPresenter = PostPresenter()
    
    static var identifier: String {
        return "recommendedCollectionCell"
    }
    
    static var cellSize: CGSize {
        return  CGSize(width: 366, height: 306)
    }
    
    static var nibName: String {
        return "RecommendedPostCollectionViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerIconView.roundCorners(corners: [.bottomLeft], radius: 100.0)
    }
    
    func setupCell(){
        descriptionPostLabel.text = presenter.post.content
        userNameLabel.text = presenter.post.author!.fullName
        timeLabel.text = presenter.post.createdDate!.timeSinceNow()
        presenter.getIconPost(iconImage: typePostImage, height: heightPostIconConstraint, width: widthPostIconConstraint)
        userImage.getUserImage(profile: presenter.post.author!) { (success, msg) in
        }
        
        presenter.getCountPhotos()
        presenter.getCoverOfPost { (success, msg, image) in
            if success {
                self.postImage.image = image!
            } else {
                print ("FAIL COVER POST")
            }
        }
    }
}
