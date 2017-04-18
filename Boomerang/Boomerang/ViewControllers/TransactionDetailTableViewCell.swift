//
//  TransactionDetailTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 12/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class TransactionDetailTableViewCell: UITableViewCell {

    var presenter = TransactionCellPresenter()
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameUserLabel: UILabel!
    @IBOutlet weak var dateTransactionLabel: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
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
        //presenter.setViewDelegate(view: self)
       // presenter.downloadImageUser()
        containerView.layer.cornerRadius = 5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//extension TransactionDetailTableViewCell: CellDelegate {
//    
//    func startLoadingPhoto() {
//        userImage.loadAnimation()
//    }
//    
//    func finishLoadingPhoto() {
//        userImage.unload()
//    }
//    
//    func showMessage(error: String) {
//        // show message error
//    }
//}
