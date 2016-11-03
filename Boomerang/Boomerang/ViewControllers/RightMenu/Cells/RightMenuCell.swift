//
//  RightMenuCell.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 03/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class RightMenuCell: UITableViewCell {
    
    @IBOutlet weak var imgViewCell: UIImageView!
    
    var cellImage: UIImage! {
        didSet{
            self.setupCell()
        }
    }
    
    func setupCell() {
        self.imgViewCell.image = self.cellImage
    }
}
