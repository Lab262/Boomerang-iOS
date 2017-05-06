//
//  TransactionDetailPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 18/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

protocol TransactionDetailDelegate {
    func showMessage(msg: String)
    func reload()
    func startingLoadingView()
    func finishLoadingView()
    func pushForChatView()
}

class TransactionDetailPresenter: NSObject {

    fileprivate var scheme: Scheme = Scheme()
    fileprivate var view: TransactionDetailDelegate?
    fileprivate var user: User = ApplicationState.sharedInstance.currentUser!
    fileprivate var chat: Chat = Chat()
    
    func setViewDelegate(view: TransactionDetailDelegate) {
        self.view = view
    }
    
    func getUser() -> User {
        return user
    }
    
    func setScheme(scheme: Scheme) {
        self.scheme = scheme
    }
    
    func getScheme() -> Scheme {
        return scheme
    }
    
    func getCreatedPost() -> Date {
        return scheme.post!.createdDate!
    }
    
    func setChat(chat: Chat) {
        self.chat = chat
    }
    
    func getChat() -> Chat {
        return chat
    }
    
    func getUserOwnATransaction() -> Profile {
        if getScheme().owner == self.user.profile {
            return getScheme().requester!
        } else {
            return getScheme().owner!
        }
    }
 
    func fetchChat() {
        self.view?.startingLoadingView()
        ChatRequest.getChatOf(requester: getScheme().requester!, owner: getScheme().owner!, post: getScheme().post!) { (success, msg, chat) in
            if success {
                self.setChat(chat: chat!)
                self.view?.pushForChatView()
            } else {
                self.view?.showMessage(msg: msg)
            }
            self.view?.finishLoadingView()
        }
    }

}
