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
    
    var scheme: Scheme = Scheme()
    fileprivate var view: TransactionDetailCellDelegate?
    var profile: Profile = User.current()!.profile!
    
    func setViewDelegate(view: TransactionDetailCellDelegate) {
        self.view = view
    }
    
    func getPostName() -> String {
        return scheme.post!.title!
    }
    
    func getStartDateScheme() -> Date {
        return scheme.createdDate!
    }
    
    func getTypeTransaction() -> TypePostEnum {
        return scheme.post!.typePostEnum!
    }
    
    func getUserOwnATransaction() -> Profile {
        return self.scheme.dealer!
//        if scheme.owner == self.profile {
//            return scheme.requester!
//        } else {
//            return scheme.owner!
//        }
    }
    
    func getTitleOfTransaction() -> String {
        switch getTypeTransaction() {
        case .have:
            return TransactionTitles.have
        case .donate:
            return TransactionTitles.donate
        case .need:
            return TransactionTitles.need
        }
    }
    
    func getImageOfUser(){
        view?.startLoadingPhoto()
        getUserOwnATransaction().getDataInBackgroundBy(key: #keyPath(User.photo), completionHandler: { (success, msg, data) in
            if success {
                self.view?.photo = UIImage(data: data!)
            } else {
                self.view?.showMessage(error: msg)
            }
            self.view?.finishLoadingPhoto()
            
        })
    }

}
