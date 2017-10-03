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
    var profile: Profile = User.current()!.profile!
    var chat: Chat = Chat()
    
    func setViewDelegate(view: TransactionDetailDelegate) {
        self.view = view
    }

    func getCreatedPost() -> Date {
        return scheme.post!.createdAt!
    }
    
    func seeScheme() {
        if !scheme.beenSeen {
            SchemeRequest.see(scheme: scheme) { (success, msg) in
                if success {
                } else {
                }
            }
        }
    }
    
    func userRated() -> Bool {
        if scheme.owner?.objectId == profile.objectId {
            if scheme.ownerEvaluated == true {
                return true
            } else {
                return false
            }
        } else {
            if scheme.requesterEvaluated == true {
                return true
            } else {
                return false
            }
        }
    }
    
    func getDealerTransaction() -> Profile {
        if scheme.owner?.objectId == profile.objectId {
            return scheme.requester!
        } else {
            return scheme.owner!
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
