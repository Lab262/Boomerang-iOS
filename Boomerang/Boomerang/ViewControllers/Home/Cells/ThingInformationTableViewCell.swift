//
//  ThingInformationTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 01/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class ThingInformationTableViewCell: UITableViewCell {
    
    @IBOutlet var evaluationButtons: [UIButton]!
    @IBOutlet weak var thingImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var boomerUserLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionThingLabel: UILabel!
    
    
    static let identifier = "thingInformationCell"
    
    var actionDelegate: ButtonActionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func leftButtonAction(_ sender: Any) {
        self.actionDelegate?.actionButtonDelegate(actionType: .back)
    }
    
    @IBAction func rightButtonAction(_ sender: Any) {
        self.actionDelegate?.actionButtonDelegate(actionType: .like)
        
    }
    
    
}
