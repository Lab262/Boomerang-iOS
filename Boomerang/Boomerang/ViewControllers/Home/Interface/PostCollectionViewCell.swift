//
//  PostCollectionViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 16/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return "postCollectionCell"
    }
    
    static var cellSize: CGSize {
        return CGSize(width: 270, height: 227)
    }

    static var nibName: String {
        return "PostCollectionViewCell"
    }
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeIconImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var heightIconPostImage: NSLayoutConstraint!
    @IBOutlet weak var widthIconPostImage: NSLayoutConstraint!
    var presenter = PostPresenter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureDynamicFont()
        setupViewDelegate()
    }
    
    func setupViewDelegate(){
        presenter.setViewDelegate(view: self)
    }
    
    func configureDynamicFont(){
        self.titleLabel.setDynamicFont()
        self.dateLabel.setDynamicFont()
        self.cityLabel.setDynamicFont()
    }
    
    func setupCell(){
        titleLabel.text = presenter.post.title
        presenter.getIconPost(iconImage: typeIconImage, height: heightIconPostImage, width: widthIconPostImage)
        userImage.getUserImage(profile: presenter.post.author!) { (success, msg) in
        }
        
        dateLabel.text = presenter.post.createdDate!.timeSinceNow()
        
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

extension PostCollectionViewCell: ViewDelegate {
    func reload() {
        setupCell()
    }
    
    func showMessageError(msg: String) {
        
    }
}
