//
//  AddBoomerCell.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 09/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class AddBoomerCell: UITableViewCell {

    static var cellIdentifier = "AddBoomerCell"
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    var boomerCellData : BoomerCellData! {
        didSet {
            self.setupCell()
        }
    }
    
    func setupCell() {
        self.photoImageView.image = boomerCellData.dataPhoto
        self.titleLabel.text = boomerCellData.dataTitle
        self.subLabel.text = boomerCellData.dataDescription
    }
    
    @IBAction func addBoomerActiona(_ sender: UIButton) {
        print("add boomer")
    }
    

}
