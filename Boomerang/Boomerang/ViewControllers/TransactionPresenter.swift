//
//  TransactionPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import ParseLiveQuery


class TransactionPresenter: NSObject {
    
    fileprivate let pagination = Paginations.schemes
    var schemes: [Scheme] = [Scheme]()
    var scheme: Scheme = Scheme()
    fileprivate var view: ViewDelegate?
    var profile: Profile = User.current()!.profile!
    var notContainedStatusScheme: [StatusSchemeEnum] = [StatusSchemeEnum]()
    
    fileprivate let liveQueryClient = ApplicationState.sharedInstance.liveQueryClient
    fileprivate var subscriptionOwnerSchemeCreated: Subscription<Scheme>?
    fileprivate var subscriptionOwnerSchemeUpdated: Subscription<Scheme>?
    fileprivate var subscriptionOwnerSchemeDeleted: Subscription<Scheme>?
    fileprivate var subscriptionRequesterSchemeCreated: Subscription<Scheme>?
    fileprivate var subscriptionRequesterSchemeUpdated: Subscription<Scheme>?
    fileprivate var subscriptionRequesterSchemeDeleted: Subscription<Scheme>?
    
    func setViewDelegate(view: ViewDelegate) {
        self.view = view
    }
    
  
    // MARK: ARRUMAR ESSA MERDA
    
    func getTransactions() {
        requestSchemeUser()
    }
    
    private func requestSchemeUser(){
        SchemeRequest.getSchemesForUser(owner: profile, schemesDownloaded: schemes, notContainedStatus: notContainedStatusScheme, pagination: pagination) { (success, msg, schemes) in
            
            if success {
                for scheme in schemes! {
                    self.schemes.append(scheme)
                }
                self.view?.reload()
            } else {
                self.view?.showMessageError(msg: msg)
            }
        }
    }
    
    private func requestSchemeStatus(completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        SchemeRequest.getAllStatus { (success, msg) in
            completionHandler(success, msg)
        }
    }
    
    fileprivate func requestOwnerSchemesUser() {
        SchemeRequest.getOwnerSchemesForUser(owner: profile, schemesDownloaded: schemes, notContainedStatus: notContainedStatusScheme, pagination: pagination) { (success, msg, schemes) in
            
            if success {
                for scheme in schemes! {
                    self.schemes.append(scheme)
                }
                self.view?.reload()
            } else {
                self.view?.showMessageError(msg: msg)
            }
        }
    }
    
    fileprivate func requestRequesterSchemesUser(){
        SchemeRequest.getRequesterSchemesForUser(requester: profile, schemesDownloaded: schemes, notContainedStatus: notContainedStatusScheme, pagination: pagination) { (success, msg, schemes) in
            
            if success {
                for scheme in schemes! {
                    self.schemes.append(scheme)
                }
                self.view?.reload()
            } else {
                self.view?.showMessageError(msg: msg)
            }
        }
    }
}

//MARK - Live Querys

extension TransactionPresenter {
    
    fileprivate var schemeOwnerQuery: PFQuery<Scheme>? {
        return (Scheme.query()?
            .whereKey(SchemeKeys.owner, equalTo: profile)
            .order(byAscending: ObjectKeys.createdAt) as! PFQuery<Scheme>)
    }
    
    fileprivate var schemeRequesterQuery: PFQuery<Scheme>? {
        return (Scheme.query()?
            .whereKey(SchemeKeys.requester, equalTo: profile)
            .order(byAscending: ObjectKeys.createdAt) as! PFQuery<Scheme>)
    }
    
    

    func setupSubscriptions() {
        subscriptionToOwnerSchemeQuery()
        subscriptionToRequesterSchemeQuery()
    }
    
    func subscriptionToOwnerSchemeQuery() {
        subscriptionOwnerSchemeCreated = liveQueryClient
            .subscribe(schemeOwnerQuery!)
            .handle(Event.created) { _, scheme in
                self.requestOwnerSchemesUser()
        }
        
        subscriptionOwnerSchemeUpdated = liveQueryClient
            .subscribe(schemeOwnerQuery!)
            .handle(Event.updated) { _, scheme in
                for (index, s) in self.schemes.enumerated() where
                    s.objectId! == scheme.objectId! {
                        self.schemes.remove(at: index)
                }
                
                self.requestOwnerSchemesUser()
                
        }
        
        subscriptionOwnerSchemeDeleted = liveQueryClient
            .subscribe(schemeOwnerQuery!)
            .handle(Event.deleted) { _, scheme in
                self.requestOwnerSchemesUser()
        }
    }
    

    func subscriptionToRequesterSchemeQuery() {
        subscriptionRequesterSchemeCreated = liveQueryClient
            .subscribe(schemeRequesterQuery!)
            .handle(Event.created) { _, scheme in
                self.requestRequesterSchemesUser()
                
        }
        
        subscriptionRequesterSchemeUpdated = liveQueryClient
            .subscribe(schemeRequesterQuery!)
            .handle(Event.updated) { _, scheme in
                
                for (index, s) in self.schemes.enumerated() where
                    s.objectId! == scheme.objectId! {
                        self.schemes.remove(at: index)
                }

                self.requestRequesterSchemesUser()
        }
        
        subscriptionRequesterSchemeDeleted = liveQueryClient
            .subscribe(schemeRequesterQuery!)
            .handle(Event.deleted) { _, scheme in
                self.requestRequesterSchemesUser()
        }
    }
}


