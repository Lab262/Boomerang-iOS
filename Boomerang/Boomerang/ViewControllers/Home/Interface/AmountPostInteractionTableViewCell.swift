//
//  AmountPostInteractionTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 20/08/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class AmountPostInteractionTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return "amountPostCell"
    }
    
    static var cellHeight: CGFloat {
        return 44.0
    }
    
    static var nibName: String {
        return "AmountPostInteractionTableViewCell"
    }

    @IBOutlet weak var likeAmountButton: UIButton!
    
    @IBOutlet weak var commentAmountButton: UIButton!
    
    @IBOutlet weak var recommendationAmountButton: UIButton!
    
    var presenter = AmountPostInteractionPresenter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        presenter.setViewDelegate(delegate: self)
        
    }
    
    @IBAction func likedPost(_ sender: Any) {
        presenter.likedPost()
    }
    
    
    
}

extension AmountPostInteractionTableViewCell: AmountPostDelegate {
    
    func showMessage(isSuccess: Bool, msg: String) {
        
    }
}
