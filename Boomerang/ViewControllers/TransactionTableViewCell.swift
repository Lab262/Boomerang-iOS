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
    
    var presenter = TransactionCellPresenter()
    
    var fromImage: UIImage? {
        didSet{
            fromUserImage.image = fromImage
            self.toUserImage.getUserImageFrom(file: presenter.currentProfile.photo!) { (success, msg) in
            }
        }
    }
    
    var toImage: UIImage? {
        didSet{
            toUserImage.image = toImage
            
            self.fromUserImage.getUserImageFrom(file: presenter.currentProfile.photo!) { (success, msg) in
            }
        }
    }
    
    var descriptionTransaction: NSMutableAttributedString? {
        didSet{
            transactionLabel.attributedText = descriptionTransaction
           
        }
    }
    
    static var identifier: String {
        return "transactionCell"
    }
    
    static var cellHeight: CGFloat {
        return 120.0
    }
    
    static var nibName: String {
        return "TransactionTableViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        presenter.setViewDelegate(view: self)
        containerView.layer.cornerRadius = 9
        configureDynamicFont()
    }
    
    func configureDynamicFont(){
        transactionLabel.setDynamicFont()
        devolutionLabel.setDynamicFont()
    }
    
    func updateCell(){
        if presenter.schemeBeenSeen() {
            containerView.borderColor = UIColor.clear
            containerView.borderWidth = 0.0
        } else {
            containerView.borderColor = UIColor.yellowBoomerColor
            containerView.borderWidth = 2.0
        }
        presenter.getInformationsOfTransaction()
        presenter.setupDevolutionDescriptionStyle(label: devolutionLabel)
        configureDynamicFont()
    }
}

extension TransactionTableViewCell: TransactionCellDelegate {
    
    func startLoadingPhoto(typeUser: TypeUser) {
        switch typeUser {
        case .owner:
            fromUserImage.loadAnimation()
        case .requester:
            toUserImage.loadAnimation()
        }
    }
    
    func finishLoadingPhoto(typeUser: TypeUser) {
        switch typeUser {
        case .owner:
            fromUserImage.unload()
        case .requester:
            toUserImage.unload()
        }
    }
    
    func showMessage(error: String) {
        
    }
}
