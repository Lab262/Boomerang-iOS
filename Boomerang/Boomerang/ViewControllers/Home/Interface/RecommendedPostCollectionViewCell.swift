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
    
    static var identifier: String {
        return "recommendedCollectionCell"
    }
    
    static var cellHeight: CGFloat {
        return 168.0
    }
    
    static var nibName: String {
        return "RecommendedPostCollectionViewCell"
    }
    
    var post: Post! {
        didSet {
            setupCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerIconView.roundCorners(corners: [.bottomLeft], radius: 100.0)
    }
    
    func setupCell() {
        descriptionPostLabel.text = post?.content
        userNameLabel.text = post!.author!.firstName! + " " + post!.author!.lastName!
        self.getUserPhotoImage()
        self.getCountPhotos()
        self.getRelationPhotosByThing()
    }
    
    func getCountPhotos() {
        if post.countPhotos < 1 {
            post.getRelationCountInBackgroundBy(key: "photos", completionHandler: { (success, msg, count) in
                
                if success {
                    self.post.countPhotos = count!
                } else {
                    
                }
            })
        }
    }
    
    func getUserPhotoImage() {
        guard let image = post?.author?.profileImage else {
            userImage.loadAnimation()
            
            post?.author?.getDataInBackgroundBy(key: #keyPath(User.imageFile), completionHandler: { (success, msg, data) in
                
                if success {
                    self.post?.author?.profileImage = UIImage(data: data!)
                    self.userImage.image = UIImage(data: data!)
                    self.userImage.unload()
                } else {
                    // error
                }
            })
            
            return
        }
        userImage.image = image
    }
    
    func getRelationPhotosByThing(){
        if post!.photos.count > 0 {
            postImage.image = post?.photos[0]
        } else if !post!.downloadedImages {
            post?.getRelationsInBackgroundWithDataBy(key: "photos", keyFile: "imageFile", completionHandler: { (success, msg, objects, data) in
                
                if success {
                    self.post?.photos.append(UIImage(data: data!)!)
                    if self.post!.photos.count < 2 {
                        self.postImage.image = UIImage(data: data!)!
                    }
                    self.post?.downloadedImages = true
                    self.postImage.unload()
                    
                } else {
                    
                }
            })
        } else {
            self.postImage.image = UIImage(named: "foto_dummy")
        }
    }
    
    override func prepareForReuse() {
        
    }
}
