//
//  HomeCollectionHeader.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 07/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class HomeCollectionHeader: UITableViewCell {

    static let cellIdentifier = "HomeCollectionHeader"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationIndicatorImageView: UIImageView!
    
    var headerData: (title: String, isLocation: Bool)! {
        didSet {
            setupCell()
        }
    }
    
    func setupCell() {
        
        self.locationIndicatorImageView.isHidden = !headerData.isLocation
        self.titleLabel.text = headerData.title
        
    }

}
