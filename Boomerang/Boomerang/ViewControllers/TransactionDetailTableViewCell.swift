//
//  TransactionDetailTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 12/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class TransactionDetailTableViewCell: UITableViewCell {

    var presenter = TransactionPresenter()
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameUserLabel: UILabel!
    @IBOutlet weak var dateTransactionLabel: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    
    static var identifier: String {
        return "transactionDetailCell"
    }
    
    static var cellHeight: CGFloat {
        return 467.0
    }
    
    static var nibName: String {
        return "TransactionDetailTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
