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
    var sender: Profile = User.current()!.profile!
    var friends: [Profile] = [Profile]()
    var recommendations: [Recommended] = [Recommended]()
    
    private var view: RecommendedDelegate?
    
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
        UserRequest.fetchFollowing(fromProfile: sender, followingDownloaded: friends, pagination: Paginations.friends) { (success, msg, profiles) in
            if success {
                profiles!.forEach {
                    self.friends.append($0)
                }
                self.getRecommendations()
            } else {
                self.view?.showMessage(success: success, msg: msg)
            }
        }
    }
    
    func getRecommendations() {
        RecommendedRequest.fetchRecommendations(sender: sender, post: post!, receivers: friends, pagination: Paginations.recommendations, recommendationsDownloaded: recommendations) { (success, msg, recommendations) in
            
            if success {
                recommendations!.forEach {
                    self.recommendations.append($0)
                }
                self.checkFriendRecommended()
                self.view?.reload()
            } else {
                self.view?.showMessage(success: success, msg: msg)
            }
            
        }
    }

    private func checkFriendRecommended() {
        for recommendation in recommendations {
            for friend in friends where recommendation.receiver?.objectId == friend.objectId {
                friend.isRecommended = true
            }
        }
    }
}
