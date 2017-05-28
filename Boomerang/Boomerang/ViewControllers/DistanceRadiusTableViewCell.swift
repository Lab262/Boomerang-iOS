//
//  DistanceRadiusTableViewCell.swift
//  Boomerang
//
//  Created by Felipe perius on 27/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class DistanceRadiusTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sliderRadius: UISlider!
    @IBOutlet weak var lessButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var numberKMlabel: UILabel!
    static var identifier: String {
        return "DistanceRadiusCell"
    }
    
    static var cellHeight: CGFloat {
        return 150
    }
    
    static var nibName: String {
        return "DistanceRadiusTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
