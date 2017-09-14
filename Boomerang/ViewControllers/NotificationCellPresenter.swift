//
//  NotificationCellPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 25/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

protocol NotificationCellDelegate {
    func startLoadingPhoto()
    func finishLoadingPhoto()
    func showMessage(error: String)
    var photo: UIImage? {get set}
}


class NotificationCellPresenter: NSObject {
    
    fileprivate let pagination = 3
    fileprivate var skip = 0
    fileprivate var notification: NotificationModel?
    fileprivate var view: NotificationCellDelegate?
    fileprivate var user: User = User.current()!
    
    func setViewDelegate(view: NotificationCellDelegate) {
        self.view = view
    }
    
    func getNotification() -> NotificationModel {
        return notification!
    }
    
    func setNotification(notification: NotificationModel) {
        self.notification = notification
    }
    
    func getUser() -> User {
        return self.user
    }
    
    func getNotificationSender() -> Profile {
        return notification!.sender!
    }
    
    func getImageOfUser(){
        view?.startLoadingPhoto()
        getNotificationSender().getDataInBackgroundBy(key: #keyPath(User.photo), completionHandler: { (success, msg, data) in
            if success {
                self.view?.photo = UIImage(data: data!)
            } else {
                self.view?.showMessage(error: msg)
            }
            self.view?.finishLoadingPhoto()
            
        })
    }
}
