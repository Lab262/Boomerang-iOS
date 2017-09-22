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
    func startFooterLoading()
    func finishFooterLoading()
}

class SearchFriendsPresenter: NSObject {
    
    private var view: SearchFriendsDelegate?
    private var pagination: Int = Paginations.profiles
    var profiles = [Profile]()
    
    func setViewDelegate(view: SearchFriendsDelegate){
        self.view = view
    }
    
    func getProfiles() {
        self.view?.startFooterLoading()
        UserRequest.getAllProfiles(profilesDownloaded: profiles, pagination: pagination) { (success, msg, profiles) in
            if success {
                if profiles!.count > 1 {
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

    func searchProfiles(searchString: String) {
        self.view?.startFooterLoading()
        UserRequest.searchProfiles(searchString: searchString, profilesDownloaded: self.profiles, pagination: Paginations.friends) { (success, msg, profiles) in
            if success {
                self.profiles = [Profile]()
                profiles!.forEach {
                    self.profiles.append($0)
                    self.view?.reload()
                }
            } else {
                self.view?.showMessage(msg: msg)
            }
            self.view?.finishFooterLoading()

        }
    }
}
