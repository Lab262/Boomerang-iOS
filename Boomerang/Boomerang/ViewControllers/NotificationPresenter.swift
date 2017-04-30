//
//  NotificationPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 25/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class NotificationPresenter: NSObject {
    
    fileprivate let pagination = 3
    fileprivate var skip = 0
    fileprivate var notifications: [NotificationModel] = [NotificationModel]()
    fileprivate var view: ViewDelegate?
    fileprivate var user: User = ApplicationState.sharedInstance.currentUser!
    
    func setViewDelegate(view: ViewDelegate) {
        self.view = view
    }
    
    func getNotifications() -> [NotificationModel] {
        return self.notifications
    }
    
    
    func getUser() -> User {
        return self.user
    }
    
    
    func requestNotifications() {
        skip = notifications.endIndex
        NotificationRequester.getNotifications(by: getUser(), pagination: pagination, skip: skip) { (success, msg, notifications) in
            
            if success {
                for notification in notifications! {
                    self.notifications.append(notification)
                }
                self.view?.reload()
            } else {
                self.view?.showMessageError(msg: msg)
            }
        }
    }
}
