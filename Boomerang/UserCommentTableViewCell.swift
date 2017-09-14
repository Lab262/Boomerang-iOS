//
//  UserCommentTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 25/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class UserCommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userPhotoImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    
    var comment: Comment? {
        didSet{
            updateCellUI()
        }
    }
    
    
    static var identifier: String {
        return "commentCell"
    }
    
    static var cellHeight: CGFloat {
        return 254.0
    }
    
    static var nibName: String {
        return "UserCommentTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureDynamicLabel()
    }
    
    func configureDynamicLabel(){
        userNameLabel.setDynamicFont()
        userDescriptionLabel.setDynamicFont()
        dateLabel.setDynamicFont()
    }

    func updateCellUI(){
        
        if let comment = comment {
            userDescriptionLabel.text = comment.content
            if let author = comment.author {
                 userNameLabel.text = author.fullName
            }
            
            if let createdAt = comment.createdAt {
                dateLabel.text = createdAt.timeSinceNow()
            }
            
            getUserPhotoImage()
        }
    }
    
    func getUserPhotoImage() {
        self.userPhotoImage.getUserImage(profile: comment!.author!) { (success, msg) in
        }
//        guard let image = comment?.author?.profileImage else {
//            userPhotoImage.loadAnimation()
//            comment?.author?.getDataInBackgroundBy(key: #keyPath(User.photo), completionHandler: { (success, msg, data) in
//                
//                if success {
//                    self.comment?.author?.profileImage = UIImage(data: data!)
//                    self.userPhotoImage.image = UIImage(data: data!)
//                    self.userPhotoImage.unload()
//                } else {
//                    // error
//                }
//            })
//            
//            return
//        }
//        
//        userPhotoImage.image = image
    }
}
