//
//  SearchFriendsCellPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 25/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit


enum FollowButtonAction {
    case follow
    case unfollow
}

protocol SearchFriendsCellDelegate {
    var following: Bool? {get set}
    func showMessage(msg: String)
    func buttonActionResult(success: Bool, action: FollowButtonAction)
}

class SearchFriendsCellPresenter: NSObject {
    
    var profile: Profile = Profile()
    fileprivate var view: SearchFriendsCellDelegate?
    
    func setViewDelegate(view: SearchFriendsCellDelegate) {
        self.view = view
    }
    
    func followAction(action: FollowButtonAction) {
        
        
        actionRequesterFor(action: action) { (success, msg) in
            if success {
                //self.view?.buttonActionResult(success: success, action: action)
                self.profile.alreadyFollow = action == .follow ? true : false
                self.view?.following = !self.view!.following!
            } else {
                self.view?.showMessage(msg: msg)
            }
        }
    }
    
    
    private func actionRequesterFor(action: FollowButtonAction, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        switch action {
        case .follow:
            let follow = Follow(from: ApplicationState.sharedInstance.currentUser!.profile!, to: profile)
            follow.saveObjectInBackground { (success, msg) in
                completionHandler(success, msg)
            }
        case .unfollow:
            UserRequest.unfollowUser(currentProfile: ApplicationState.sharedInstance.currentUser!.profile!, otherProfile: profile) { (success, msg) in
                completionHandler(success, msg)
            }
        }
    }
    
    func getIsAlreadyFollwing() {
        if let alReadyFollow = profile.alreadyFollow {
            self.view?.following = alReadyFollow
        } else {
            UserRequest.verifyAlreadyFollowingFor(currentProfile: ApplicationState.sharedInstance.currentUser!.profile!, otherProfile: profile) { (success, msg, alreadyFollow) in
                if success {
                    self.view?.following = alreadyFollow
                    self.profile.alreadyFollow = alreadyFollow
                } else {
                    self.view?.showMessage(msg: msg)
                }
            }
        }
    }
}
