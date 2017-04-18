//
//  TransactionDetailCellPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 18/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class TransactionDetailCellPresenter: NSObject {
    
    fileprivate var scheme: Scheme = Scheme()
    fileprivate var view: TransactionCellDelegate?
    fileprivate var user: User = ApplicationState.sharedInstance.currentUser!
    
    func setViewDelegate(view: TransactionCellDelegate) {
        self.view = view
    }
    
    func setScheme(scheme: Scheme) {
        self.scheme = scheme
    }
    
    func getScheme() -> Scheme {
        return self.scheme
    }
    
    func getPostName() -> String {
        return getScheme().post!.title!
    }
    
    func getUser() -> User {
        return user
    }
    
    func getRequesterOfTransaction() -> User {
        return getScheme().requester!
    }
    
    func getOwnerOfTransaction() -> User {
        return getScheme().owner!
    }
    
    func getPost() -> Post {
        return getScheme().post!
    }

}
