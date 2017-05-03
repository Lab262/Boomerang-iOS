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
    fileprivate var skipSchemes = 0
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
    
    func getTransactions() {
        skipSchemes = schemes.endIndex
        SchemeRequest.getSchemesForUser(owner: getUser().profile!, pagination: pagination, skip: skipSchemes) { (success, msg, schemes) in
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
