//
//  TransactionDetailCellPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 18/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

protocol TransactionDetailCellDelegate {
    func startLoadingPhoto()
    func finishLoadingPhoto()
    func showMessage(error: String)
    var photo: UIImage? {get set}
}

class TransactionDetailCellPresenter: NSObject {
    
    fileprivate var scheme: Scheme = Scheme()
    fileprivate var view: TransactionDetailCellDelegate?
    fileprivate var user: User = ApplicationState.sharedInstance.currentUser!
    
    func setViewDelegate(view: TransactionDetailCellDelegate) {
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
    
    func getStartDateScheme() -> Date {
        return getScheme().createdDate!
    }
    
    func getTypeTransaction() -> PostType {
        return getScheme().post!.postType!
    }
    
    func getUser() -> User {
        return user
    }
    
    func getUserOwnATransaction() -> User {
        if getScheme().owner == self.user {
            return getScheme().requester!
        } else {
            return getScheme().owner!
        }
    }
    
    func getTitleOfTransaction() -> String {
        switch getTypeTransaction() {
        case .have:
            return "Empréstimo feito com"
        case .donate:
            return "Doação feita com"
        case .need:
            return "Troca feita com"
        }
    }
    
    func getImageOfUser(){
        view?.startLoadingPhoto()
        getUserOwnATransaction().getDataInBackgroundBy(key: #keyPath(User.imageFile), completionHandler: { (success, msg, data) in
            if success {
                self.view?.photo = UIImage(data: data!)
            } else {
                self.view?.showMessage(error: msg)
            }
            self.view?.finishLoadingPhoto()
            
        })
    }

}
