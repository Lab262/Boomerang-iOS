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
    var radiusKM:Int =  100
    
    static var identifier: String {
        return "DistanceRadiusCell"
    }
    
    static var cellHeight: CGFloat {
        return 140
    }
    
    static var nibName: String {
        return "DistanceRadiusTableViewCell"
    }
    @IBAction func moreAction(_ sender: Any) {
        if self.radiusKM < 800{
            self.radiusKM += 100
            self.numberKMlabel.text = ("\(self.radiusKM)KM")
            self.sliderRadius.value = Float(self.radiusKM)
        }
    }
  
    @IBAction func lessAction(_ sender: Any) {
        if self.radiusKM > 100{
            self.radiusKM -= 100
            self.numberKMlabel.text = ("\(self.radiusKM)KM")
            self.sliderRadius.value = Float(self.radiusKM)
        }
        
    }
    
    @IBAction func sliderAction(_ sender: Any) {
        let numberRadius = Int(self.sliderRadius.value)
        self.radiusKM = numberRadius
        self.numberKMlabel.text =  ("\(numberRadius)KM")
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.numberKMlabel.text = ("\(self.radiusKM)KM")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
