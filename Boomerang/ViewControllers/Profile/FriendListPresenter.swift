//
//  FriendListPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 11/09/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

protocol FriendListDelegate {
    func reload()
    func loadingView()
    func unloadingView()
    func showMessage(msg: String)
    func startFooterLoading()
    func finishFooterLoading()
}

class FriendListPresenter: NSObject {
    
    private var view: FriendListDelegate?
    private var pagination: Int = Paginations.profiles
    var profiles = [Profile]()
    var profile = Profile()
    var isFollowers: Bool = false
    
    func setViewDelegate(view: FriendListDelegate){
        self.view = view
    }
    
    func getTitleView() -> String {
        return isFollowers ? "Seguidores" : "Seguindo"
    }
    
    func isFetchAlreadyFollowing() -> Bool {
        return isFollowers ? true : false
    }
    
    func getProfiles() {
        self.view?.startFooterLoading()
        
        UserRequest.fetchProfileFriends(fromProfile: profile, followingDownloaded: profiles, isFollowers: isFollowers, pagination: Paginations.friends) { (success, msg, profiles) in
            
            if success {
                if profiles!.count > 0 {
                    profiles!.forEach {
                        self.profiles.append($0)
                        self.view?.reload()
                    }
                }
                self.view?.finishFooterLoading()
            } else {
                self.view?.showMessage(msg: msg)
                self.view?.finishFooterLoading()
            }
        }
    }
}
