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
    
    var presenter: DetailThingPresenter = DetailThingPresenter()
    
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
        configureDynamicFont()
    }
    
    func configureDynamicFont(){
        userNameLabel.setDynamicFont()
        dateLabel.setDynamicFont()
        cityLabel.setDynamicFont()
    }
    

    func updateCellUI(){
        userNameLabel.text = presenter.post.author!.fullName
        dateLabel.text = presenter.post.createdDate!.timeSinceNow()
        
        
        userImage.getUserImageFrom(file: presenter.post.author!.photo!) { (success, msg) in
            
        }
    }
}


