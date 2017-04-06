//
//  TransactionTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var fromUserImage: UIImageView!
    @IBOutlet weak var toUserImage: UIImageView!
    @IBOutlet weak var transactionLabel: UILabel!
    @IBOutlet weak var devolutionLabel: UILabel!
    
    var presenter = TransactionPresenter()
    
    static var identifier: String {
        return "transactionCell"
    }
    
    static var cellHeight: CGFloat {
        return 120.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.cornerRadius = 9
    }
    
    

}
