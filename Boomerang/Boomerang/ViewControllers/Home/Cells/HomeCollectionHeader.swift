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
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.window?.endEditing(true)
    }
}
