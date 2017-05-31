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
        configureDynamicFont()
        setupViewDelegate()
    }
    
    func setupViewDelegate() {
        presenter.setViewDelegate(view: self)
    }
    
    func configureDynamicFont(){
        userNameLabel.setDynamicFont()
        descriptionPostLabel.setDynamicFont()
        commentAmountLabel.setDynamicFont()
        likeAmountLabel.setDynamicFont()
        sharedAmountLabel.setDynamicFont()
    }
    
    
    func setupCell(){
        descriptionPostLabel.text = presenter.post.title!
        userNameLabel.text = presenter.post.author!.fullName
        
        let userName = NSMutableAttributedString(string: presenter.post.author!.fullName, attributes: [NSFontAttributeName : UIFont.montserratSemiBold(size: 13.0),NSForegroundColorAttributeName:UIColor.black])
        
        let time = NSMutableAttributedString(string: "     " + presenter.post.createdDate!.timeSinceNow(), attributes: [NSFontAttributeName : UIFont.montserratRegular(size: 9.0),NSForegroundColorAttributeName:UIColor.timeColor])
        
        userName.append(time)
        
        userNameLabel.attributedText = userName
        
        presenter.getIconPost(iconImage: typePostImage, height: heightPostIconConstraint, width: widthPostIconConstraint)
        userImage.getUserImage(profile: presenter.post.author!) { (success, msg) in
        }
        
        //presenter.getCountPhotos()
        presenter.getCoverOfPost { (success, msg, image) in
            if success {
                self.postImage.image = image!
            } else {
                print ("FAIL COVER POST")
            }
        }
    }
}

extension RecommendedPostCollectionViewCell: ViewDelegate {
    
    func reload() {
        setupCell()
    }
    
    func showMessageError(msg: String) {
        
    }
}
