//
//  UserInformationTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 21/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class UserInformationTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet var evaluationStarImage: [UIImageView]!
    
    var post: Post? {
        didSet{
            updateCellUI()
        }
    }
    
    static var identifier: String {
        return "userInformationCell"
    }
    
    static var cellHeight: CGFloat {
        return 75.0
    }
    
    static var nibName: String {
        return "UserInformationTableViewCell"
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    func updateCellUI(){
        userNameLabel.text = post!.author!.fullName
        //dateLabel.text = post!.createdDate!.getStringToDate(dateFormat: "dd/MM/yyyy")
        dateLabel.text = post?.createdDate?.getFormatterDate()
        getUserPhotoImage()
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
    
}
