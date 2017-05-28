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
    var descriptionTransaction: NSMutableAttributedString? {get set}
}

class TransactionCellPresenter: NSObject {
    
    var scheme: Scheme = Scheme()
    fileprivate var view: TransactionCellDelegate?
    var user: User = ApplicationState.sharedInstance.currentUser!
    
    func setViewDelegate(view: TransactionCellDelegate) {
        self.view = view
    }
    
    func getPostName() -> String {
        return scheme.post!.title!
    }
    
    func getRequesterOfTransaction() -> Profile {
        return scheme.requester!
    }
    
    func getOwnerOfTransaction() -> Profile {
        return scheme.owner!
    }
    
    func getPost() -> Post {
        return scheme.post!
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
    
    func setupDevolutionDescriptionStyle(label: UILabel) {
        if scheme.statusScheme == .negotiation {
            label.font = UIFont.montserratRegular(size: 13)
            label.textColor = UIColor.yellowTransactioColor
        } else if scheme.post?.postCondition == .loan {
            label.font = UIFont.montserratLight(size: 13)
            label.textColor = UIColor.black
        } else {
            label.text = ""
        }
    }
    
    func getInformationsTransactionByTypeOfPost(isFromUser: Bool, postCondition: Condition) {
        
        //Get Image
        if isFromUser {
            getImageOfUser(user: getRequesterOfTransaction(), type: .requester)
        }else{
            getImageOfUser(user: getOwnerOfTransaction(), type: .owner)
        }
        
        //Get string
        var descriptionTransaction: NSMutableAttributedString?
        
        switch postCondition {
            
            case .donation:
                if isFromUser {
                    descriptionTransaction = getCustomAttributtedTextStartsWithPhrase(title: TransactionCellStrings.titleDonate)
                } else {
                    descriptionTransaction = getCustomAttributtedTextStartsWithName(title: TransactionCellStrings.actionDonate)
                    
                }
            case .loan:
                if isFromUser {
                    descriptionTransaction = getCustomAttributtedTextStartsWithPhrase(title: TransactionCellStrings.titleLoan)
                
                } else {
                    descriptionTransaction = getCustomAttributtedTextStartsWithName(title: TransactionCellStrings.actionLoan)
                }
            case .exchange:
                if isFromUser {
                    descriptionTransaction = getCustomAttributtedTextStartsWithPhrase(title: TransactionCellStrings.titleExchange)
                } else {
                    
                    descriptionTransaction = getCustomAttributtedTextStartsWithName(title: TransactionCellStrings.actionExchange)
                }
        }
        
        view?.descriptionTransaction = descriptionTransaction
    }
    
    func getInformationsOfTransaction(){
        if scheme.owner?.objectId == self.user.profile?.objectId {
            scheme.dealer = scheme.requester
            getInformationsTransactionByTypeOfPost(isFromUser: true, postCondition: getPost().postCondition!)
           // view?.fromImage = self.user.photo.getdata
        } else {
            scheme.dealer = scheme.owner
            getInformationsTransactionByTypeOfPost(isFromUser: false, postCondition: getPost().postCondition!)
            //iew?.toImage = self.user.profileImage
        }
    }
    
    func getCustomAttributtedTextStartsWithPhrase(title: String) -> NSMutableAttributedString{
        
        let title = getCustomAttributedString(text: title, isPhrase: true)
        let namePost = getCustomAttributedString(text: getPostName(), isPhrase: false)
        let forString = getCustomAttributedString(text: TransactionCellStrings.forAction, isPhrase: true)
        let nameUser = getCustomAttributedString(text: getRequesterOfTransaction().fullName, isPhrase: false)
        
        title.append(namePost)
        title.append(forString)
        title.append(nameUser)
        
        return title
        
    }
    
    func getCustomAttributtedTextStartsWithName(title:String) -> NSMutableAttributedString{
        
        let nameUser = getCustomAttributedString(text: getOwnerOfTransaction().fullName, isPhrase: false)
        let actionTitle = getCustomAttributedString(text: title, isPhrase: true)
        let namePost = getCustomAttributedString(text: getPostName(), isPhrase: false)
        
        nameUser.append(actionTitle)
        nameUser.append(namePost)
        
        return nameUser
    }
    
    func getCustomAttributedString(text: String, isPhrase: Bool) -> NSMutableAttributedString {
        if isPhrase{
            return NSMutableAttributedString(string: text, attributes: [NSForegroundColorAttributeName: UIColor.greyTransactionColor, NSFontAttributeName: UIFont.montserratRegular(size: 14)])
        }else{
            return NSMutableAttributedString(string: text, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.montserratSemiBold(size: 14)])
        }
    }
}
