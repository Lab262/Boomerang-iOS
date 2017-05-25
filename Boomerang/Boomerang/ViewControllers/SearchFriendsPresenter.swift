//
//  SearchFriendsPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 25/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

protocol SearchFriendsDelegate {
    func reload()
    func loadingView()
    func unloadingView()
    func showMessage(msg: String)
}

class SearchFriendsPresenter: NSObject {
    
    private var view: SearchFriendsDelegate?
    private var pagination: Int = Paginations.profiles
    var profiles = [Profile]()
    
    func setViewDelegate(view: SearchFriendsDelegate){
        self.view = view
    }
    
    func getProfiles() {
        UserRequest.getAllProfiles(profilesDownloaded: profiles, pagination: pagination) { (success, msg, profiles) in
            if success {
                profiles!.forEach {
                    self.profiles.append($0)
                }
                self.view?.unloadingView()
                self.view?.reload()
            } else {
                self.view?.showMessage(msg: msg)
                
            }
        }
    }
}
