//
//  NotificationPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 25/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import ParseLiveQuery

class NotificationPresenter: NSObject {
    
    fileprivate let pagination = Paginations.notifications
    fileprivate var skip = 0
    fileprivate var notifications: [NotificationModel] = [NotificationModel]()
    fileprivate var view: ViewDelegate?
    fileprivate var user: User = ApplicationState.sharedInstance.currentUser!
    fileprivate let liveQueryClient = ApplicationState.sharedInstance.liveQueryClient
    
    fileprivate var subscriptionNotificationCreated: Subscription<NotificationModel>?
    
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
        
        NotificationRequester.getNotifications(profile: getUser().profile!, notificationDownloaded: self.notifications, pagination: pagination) { (success, msg, notifications) in
            
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

//MARK - Live Querys

extension NotificationPresenter {
    
    fileprivate var notificationQuery: PFQuery<NotificationModel>? {
        return (NotificationModel.query()?
            .whereKey(NotificationModelKeys.receiver, equalTo: self.user.profile!)
            .order(byAscending: ObjectKeys.createdAt) as! PFQuery<NotificationModel>)
    }
    

    func setupSubscribes() {
        subscribeToNotification()
    }
    
    func subscribeToNotification() {
        subscriptionNotificationCreated = liveQueryClient
            .subscribe(notificationQuery!)
            .handle(Event.created) { _, follow in
                self.requestNotifications()
        }
    }
}


