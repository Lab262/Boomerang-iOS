//
//  OnboardAuthenticationCollectionViewCell.swift
//  Boomerang
//
//  Created by Luís Resende on 13/09/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class OnboardAuthenticationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    static var identifier: String {
        return "onboardAuthenticationCollectionViewCell"
    }
    
    static var cellSize: CGSize {
        return  CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.3)
    }
    
    static var nibName: String {
        return "OnboardAuthenticationCollectionViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionLabel.setDynamicFont()
    }
    
    var onboardData : [String:Any]! {
        didSet {
            self.setupCell()
        }
    }
    
    func setupCell() {
        self.imageView.image = onboardData[OnboardCellKeys.keyImageView] as? UIImage
        self.descriptionLabel.text = onboardData[OnboardCellKeys.keyDescriptionLabel] as? String
    }
}
