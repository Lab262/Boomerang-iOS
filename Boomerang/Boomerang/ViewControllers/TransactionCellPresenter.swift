//
//  TransactionCellPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 17/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

enum TypeUser {
    case owner
    case requester
}

protocol TransactionCellDelegate {
    func startLoadingPhoto(typeUser: TypeUser)
    func finishLoadingPhoto(typeUser: TypeUser)
    func showMessage(error: String)
    var fromImage: UIImage? {get set}
    var toImage: UIImage? {get set}
    var descriptionTransaction: String? {get set}
}

class TransactionCellPresenter: NSObject {
    
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
    
    
    func getRequesterOfTransaction() -> Profile {
        return getScheme().requester!
    }
    
    func getOwnerOfTransaction() -> Profile {
        return getScheme().owner!
    }
    
    func getPost() -> Post {
        return getScheme().post!
    }
    
    func getImageOfUser(user: Profile, type: TypeUser){
        user.getDataInBackgroundBy(key: #keyPath(User.photo), completionHandler: { (success, msg, data) in
            
            if success {
                switch type {
                case .owner:
                    self.view?.fromImage = UIImage(data: data!)
                case .requester:
                    self.view?.toImage = UIImage(data: data!)
                }
            } else {
                self.view?.showMessage(error: msg)
            }
            
            self.view?.finishLoadingPhoto(typeUser: type)
            
        })
    }
    
    func getInformationsTransactionByTypeOfPost(isFromUser: Bool, postCondition: Condition) {
        
        var descriptionTransaction: String?
        
        switch postCondition {
            
        case .donation:
            if isFromUser {
                descriptionTransaction = "Você está doando \(getPostName()) para \(getRequesterOfTransaction().fullName)"
                getImageOfUser(user: getRequesterOfTransaction(), type: .requester)
            } else {
                descriptionTransaction = "\(getOwnerOfTransaction().fullName) está te doando \(getPostName())"
                getImageOfUser(user: getOwnerOfTransaction(), type: .owner)
            }
        case .loan:
            if isFromUser {
                descriptionTransaction = "Você está emprestando \(getPostName()) para \(getRequesterOfTransaction().fullName)"
                getImageOfUser(user: getRequesterOfTransaction(), type: .requester)
            } else {
                descriptionTransaction = "\(getOwnerOfTransaction().fullName) está te emprestando \(getPostName())"
                getImageOfUser(user: getOwnerOfTransaction(), type: .owner)
            }
        case .exchange:
            if isFromUser {
                descriptionTransaction = "\(getRequesterOfTransaction().fullName) está trocando \(getPostName())"
                getImageOfUser(user: getRequesterOfTransaction(), type: .requester)
            } else {
                descriptionTransaction = "Você está trocando \(getPostName()) para \(getOwnerOfTransaction().fullName)"
                getImageOfUser(user: getOwnerOfTransaction(), type: .owner)
            }
        }
        view?.descriptionTransaction = descriptionTransaction
    }
    
    func getInformationsOfTransaction(){
        if getScheme().owner?.objectId == self.user.profile?.objectId {
            scheme.dealer = getScheme().requester
            getInformationsTransactionByTypeOfPost(isFromUser: true, postCondition: getPost().condition!)
            view?.fromImage = self.user.profileImage
        } else {
            scheme.dealer = getScheme().owner
            getInformationsTransactionByTypeOfPost(isFromUser: false, postCondition: getPost().condition!)
            view?.toImage = self.user.profileImage
        }
    }
}
