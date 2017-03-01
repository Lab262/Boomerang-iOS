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
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var boomerUserLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionThingLabel: UILabel!
    
    static let identifier = "thingInformationCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
