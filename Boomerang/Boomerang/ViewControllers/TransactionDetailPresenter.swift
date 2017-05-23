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
    func push(identifier: String)
}

class TransactionDetailPresenter: NSObject {

    var scheme: Scheme = Scheme()
    fileprivate var view: TransactionDetailDelegate?
    var profile: Profile = ApplicationState.sharedInstance.currentUser!.profile!
    var chat: Chat = Chat()
    
    func setViewDelegate(view: TransactionDetailDelegate) {
        self.view = view
    }

    func getCreatedPost() -> Date {
        return scheme.post!.createdDate!
    }
    
    func getUserOwnATransaction() -> Profile {
        if scheme.owner == profile {
            return scheme.requester!
        } else {
            return scheme.owner!
        }
    }
    
    func finalizeScheme() {
        view?.startingLoadingView()
        SchemeRequest.finalize(for: scheme) { (success, msg) in
            if success {
                self.view?.push(identifier: SegueIdentifiers.detailTransactionToEvaluation)
            } else {
                self.view?.showMessage(msg: msg)
            }
            self.view?.finishLoadingView()
        }
    }
 
    func fetchChat() {
        self.view?.startingLoadingView()
        ChatRequest.getChatOf(requester: scheme.requester!, owner: scheme.owner!, post: scheme.post!) { (success, msg, chat) in
            if success {
                self.chat = chat!
                self.view?.push(identifier: SegueIdentifiers.detailTransactionToChat)
            } else {
                self.view?.showMessage(msg: msg)
            }
            self.view?.finishLoadingView()
        }
    }

}
