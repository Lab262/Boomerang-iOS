//
//  RecommendedPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 15/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit


protocol RecommendedDelegate{
    func reload()
    func dismissRowAction()
    func showMessage(success: Bool, msg: String)
}

class RecommendedPresenter: NSObject {
    var post: Post?
    var sender: Profile = ApplicationState.sharedInstance.currentUser!.profile!
    var friends: [Profile] = [Profile]()
    
    private var view: RecommendedDelegate?
    private var pagination: Int = 10
    
    func setViewDelegate(view: RecommendedDelegate){
        self.view = view
    }
    
    
    func createRecommendation(friend: Profile) {
        let recommendation = Recommended(sender: sender, post: post, receiver: friend)
        
        recommendation.saveObjectInBackground { (success, msg) in
            if success {
                self.view?.showMessage(success: success, msg: "Recomendação enviada :)")
            } else {
                self.view?.showMessage(success: success, msg: msg)
            }
            self.view?.dismissRowAction()
        }
    }
    
    func getFriends() {
        UserRequest.fetchFollowing(fromProfile: sender, followingDownloaded: friends, pagination: pagination) { (success, msg, profiles) in
            if success {
                profiles!.forEach {
                    self.friends.append($0)
                }
                self.view?.reload()
            } else {
                self.view?.showMessage(success: success, msg: msg)
            }
        }
    }
}
