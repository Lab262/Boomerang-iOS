//
//  TransactionPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit



class TransactionPresenter: NSObject {
    
    fileprivate let pagination = 3
    fileprivate var schemes: [Scheme] = [Scheme]()
    fileprivate var scheme: Scheme = Scheme()
    fileprivate var view: ViewDelegate?
    fileprivate var user: User = ApplicationState.sharedInstance.currentUser!
    func setViewDelegate(view: ViewDelegate) {
        self.view = view
    }
    
    func getUser() -> User {
        return user
    }
    
    func getSchemes() -> [Scheme] {
        return schemes
    }
    
    func setSchemes(schemes: [Scheme]) {
        self.schemes = schemes
    }
    
    func setScheme(scheme: Scheme) {
        self.scheme = scheme
    }
    
    func getScheme() -> Scheme {
        return scheme
    }
    
    // MARK: ARRUMAR ESSA MERDA
    
    func getTransactions() {
        if ApplicationState.sharedInstance.schemeStatus.count < 1 {
            requestSchemeStatus { (success, msg) in
                if success {
                    self.requestSchemeUser()
                } else {
                    print ("GET STATUS ERROR")
                }
            }
        } else {
            requestSchemeUser()
        }
    }
    
    func requestSchemeUser(){
        SchemeRequest.getSchemesForUser(owner: getUser().profile!, schemesDownloaded: getSchemes(), notContainedStatus: [.finished, .done, .canceled], pagination: pagination) { (success, msg, schemes) in
            
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
    
    func requestSchemeStatus(completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        SchemeRequest.getAllStatus { (success, msg) in
            completionHandler(success, msg)
        }
    }
    
    

}
