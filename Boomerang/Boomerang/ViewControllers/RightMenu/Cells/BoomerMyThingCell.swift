//
//  BoomerMessageAndNotificationsCell.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 08/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class BoomerMyThingCell: UITableViewCell {

    static var cellIdentifier = "BoomerMyThingCell"
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var boomerCellData : BoomerCellData! {
        didSet {
           self.setupCell()
        }
    }
    
    func setupCell() {
        self.photoImageView.image = boomerCellData.dataPhoto
        self.titleLabel.text = boomerCellData.dataTitle
        self.subLabel.text = boomerCellData.dataDescription
        self.descriptionLabel.text = boomerCellData.dataSubDescription
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.window?.endEditing(true)
    }
}
