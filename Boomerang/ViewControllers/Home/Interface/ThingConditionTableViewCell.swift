//
//  ThingConditionTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 22/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class ThingConditionTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return "conditionCell"
    }
    
    static var cellHeight: CGFloat {
        return 75.0
    }
    
    static var nibName: String {
        return "ThingConditionTableViewCell"
    }
    
    
    var cellData: (Fields)? {
        
        didSet{
            updateCellUI()
        }
    }
    
    @IBOutlet weak var iconHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var titleConditionLabel: UILabel!
    @IBOutlet weak var descriptionConditionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleConditionLabel.setDynamicFont()
        descriptionConditionLabel.setDynamicFont()
    }

    func updateCellUI(){
        conditionImage.image = cellData?.iconCondition
        titleConditionLabel.text = cellData?.titleCondition
        descriptionConditionLabel.text = cellData?.descriptionCondition
        iconHeightConstraint.constant = CGFloat(cellData!.constraintIconHeight)
        iconWidthConstraint.constant = CGFloat(cellData!.constraintIconWidth)
        self.layoutIfNeeded()
        
    }
    
}
