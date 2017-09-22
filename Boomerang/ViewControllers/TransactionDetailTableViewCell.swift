//
//  TransactionDetailTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 12/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class TransactionDetailTableViewCell: UITableViewCell {

    var presenter = TransactionDetailCellPresenter()
    @IBOutlet weak var profileLinkButton: UIButton!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameUserLabel: UILabel!
    @IBOutlet weak var dateTransactionLabel: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleOfTransactionLabel: UILabel!
    @IBOutlet weak var dateFinishLabel: UILabel!
    
    @IBOutlet weak var arrowRoundImage: UIImageView!
    @IBOutlet weak var finishLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var cancelButtonContainerView: UIView!
    @IBOutlet weak var chatButtonContainerView: UIView!
    @IBOutlet weak var startLabelCenterLeftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var startLabelCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var goToChatLabel: UILabel!
    
    @IBOutlet weak var cancelProcessLabel: UILabel!
    var photo: UIImage? {
        didSet {
            userImage?.image = photo
        }
    }
    
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
        presenter.setViewDelegate(view: self)
        containerView.layer.cornerRadius = 5
        configureDymaicFont()
    }
    
    func configureDymaicFont(){
        nameUserLabel.setDynamicFont()
        dateTransactionLabel.setDynamicFont()
        titleOfTransactionLabel.setDynamicFont()
        startLabel.setDynamicFont()
        goToChatLabel.setDynamicFont()
        cancelProcessLabel.setDynamicFont()
    }
    
    func updateInformationsCell(){
        nameUserLabel.text = presenter.getUserOwnATransaction().fullName
        titleOfTransactionLabel.text = presenter.getTitleOfTransaction()
        dateTransactionLabel.text = presenter.getStartDateScheme().getStringToDate(dateFormat: "dd/MM/YYYY")
        presenter.getImageOfUser()
        
        if let finalizeDate = presenter.getFinalizedDateScheme() {
            dateFinishLabel.text = finalizeDate.getStringToDate(dateFormat: "dd/MM/YYYY")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension TransactionDetailTableViewCell: TransactionDetailCellDelegate {
    
    func startLoadingPhoto() {
        userImage?.loadAnimation()
    }
    
    func finishLoadingPhoto() {
        userImage?.unload()
    }
    
    func showMessage(error: String) {
        
    }
}
