//
//  RightMenuCell.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 03/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class RightMenuCell: UITableViewCell {
    
    @IBOutlet weak var imgViewCell: UIImageView!
    @IBOutlet weak var imageBigSizeConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageSmallSizeConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundCircleView: UIView!
    
    var user = ApplicationState.sharedInstance.currentUser
    
    var cellImage: UIImage? {
        didSet{
            self.setupCell()
        }
    }
    
    func setupCell() {
        self.getUserPhoto()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.window?.endEditing(true)
    }
    
    func getUserPhoto() {
        
        guard let image = cellImage else {
            
            self.imgViewCell.loadAnimation()
            
            UserRequest.getProfilePhoto(user: user!, completionHandler: { (success, msg, photo) in
                
                if success {
                    self.imgViewCell.image = photo
                    ApplicationState.sharedInstance.currentUser?.profileImage = photo
                    self.imgViewCell.unload()
                } else {
                    // error
                }
            })
            
            return
        }
        
        self.imgViewCell.image = image
    }
    

}
