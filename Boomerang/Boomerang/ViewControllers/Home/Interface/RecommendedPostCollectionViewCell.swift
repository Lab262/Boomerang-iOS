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
    
    var thingData: BoomerThing! {
        didSet {
            setupCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerIconView.roundCorners(corners: [.bottomLeft], radius: 100.0)
    }
    
    func setupCell() {
        descriptionPostLabel.text = thingData.post?.content
        userNameLabel.text = thingData.post!.author!.firstName! + " " + thingData.post!.author!.lastName!
        
        self.getUserPhotoImage()
        self.getRelationPhotosByThing()
    }
    
    
    func getUserPhotoImage() {
        guard let image = thingData.post?.author?.profileImage else {
            userImage.loadAnimation()
            
            thingData.post?.author?.getDataInBackgroundBy(key: #keyPath(User.imageFile), completionHandler: { (success, msg, data) in
                
                if success {
                    self.thingData.post?.author?.profileImage = UIImage(data: data!)
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
        
        if thingData.post!.photos.count > 0 {
            postImage.image = thingData.post?.photos[0]
            
        } else if !thingData.post!.downloadedImages {
            thingData.post?.getRelationsInBackgroundWithDataBy(key: "photos", keyFile: "imageFile", completionHandler: { (success, msg, objects, data) in
                
                if success {
                    self.thingData.post?.photos.append(UIImage(data: data!)!)
                    
                    if self.thingData.post!.photos.count < 2 {
                        self.postImage.image = UIImage(data: data!)!
                    }
                    
                    self.postImage.unload()
                    
                } else {
                    
                }
            })
        } else {
            self.postImage.image = UIImage(named: "foto_dummy")
        }
    }
}
