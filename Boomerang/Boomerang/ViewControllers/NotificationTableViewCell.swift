//
//  NotificationTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 23/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit


class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var backgroundSupportView: UIView!
    
    var presenter = NotificationCellPresenter()
    
    var photo: UIImage? {
        didSet {
            userImage.image = photo
        }
    }
    
    static var identifier: String {
        return "notificationCell"
    }
    
    static var cellHeight: CGFloat {
        return 70.0
    }
    
    static var nibName: String {
        return "NotificationTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        presenter.setViewDelegate(view: self)
    }
    
    func setupCellInformations(){
        presenter.getImageOfUser()
        nameLabel.text = presenter.getNotificationSender().fullName
        notificationLabel.text = presenter.getNotification().notificationDescription
        timeLabel.text = presenter.getNotification().createdDate?.getStringToDate(dateFormat: "dd/MM/YYYY")
    }
}

extension NotificationTableViewCell: NotificationCellDelegate {
    
    func startLoadingPhoto() {
        userImage.loadAnimation()
    }
    
    func finishLoadingPhoto() {
        userImage.unload()
    }
    
    func showMessage(error: String) {
        
    }
}
