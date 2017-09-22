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
    @IBOutlet weak var userButton: UIButton!
    
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
        self.cityLabel.text = "Asa Norte"
        configureDynamicFont()
    }
    
    func configureDynamicFont(){
        userNameLabel.setDynamicFont()
        dateLabel.setDynamicFont()
        cityLabel.setDynamicFont()
    }
    

    func updateCellUI(){
        if let author = presenter.post.author {
            userNameLabel.text = author.fullName
        }
        
        if let createdAt = presenter.post.createdAt {
            dateLabel.text = createdAt.timeSinceNow()
        }
        
        userImage.getUserImageFrom(file: presenter.post.author!.photo!) { (success, msg) in
            
        }
        
        getAverageStars()
    }
    
    func getAverageStars(){
        
        presenter.getAverageStars { (success, msg, averageStars) in
            if success {
                for i in 0 ..< averageStars! {
                    self.evaluationStarImage[i].image = UIImage(named: "selected-star-button")
                }
            } else {
                print("AVERAGE STARS")
            }
        }
    }
}


