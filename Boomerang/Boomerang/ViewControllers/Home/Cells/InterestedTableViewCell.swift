//
//  InterestedTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 01/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class InterestedTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var interestedImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var markerImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var containerInformationsView: UIView!
    
    @IBOutlet weak var initializeSchemeButton: UIButton!
    
    static var identifier: String {
        return "interestedCell"
    }
    
    static var cellHeight: CGFloat {
        return 108.0
    }
    
    static var nibName: String {
        return "InterestedTableViewCell"
    }
    
    var presenter = InterestedPresenter()

    override func awakeFromNib() {
        super.awakeFromNib()
        configureDynamicFont()
    }
    
    func configureDynamicFont(){
        countLabel.setDynamicFont()
        nameLabel.setDynamicFont()
        messageLabel.setDynamicFont()
        dateLabel.setDynamicFont()
        cityLabel.setDynamicFont()
    }
    
    @IBAction func initializeScheme(_ sender: Any) {
        
    }
    
    
    func loadViewCell(){
        nameLabel.text = presenter.getInterested().user!.fullName
        messageLabel.text = presenter.getInterested().currentMessage!
        
        interestedImage.loadAnimation()
        presenter.getUserPhotoImage { (success, msg, image) in
            if success {
                self.interestedImage.image = image
                self.interestedImage.unload()
            } else {
                print ("ERROR INTERESTED IMAGE DOWNLOAD")
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
