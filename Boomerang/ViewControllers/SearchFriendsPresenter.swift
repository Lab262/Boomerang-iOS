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
    var currentSearchString = ""

    func setViewDelegate(view: SearchFriendsDelegate){
        self.view = view
    }
    
    func getProfiles() {
        self.view?.startFooterLoading()
        UserRequest.getAllProfiles(profilesDownloaded: profiles, pagination: pagination) { (success, msg, profiles) in
            if success {
                if profiles!.count > 1 {
                    profiles!.forEach {
                        if $0.objectId != User.current()!.profile?.objectId {
                            self.profiles.append($0)
                        }
                    }
                }
                self.view?.reload()
                self.view?.finishFooterLoading()
            } else {
                self.view?.showMessage(msg: msg)
                self.view?.finishFooterLoading()
                
            }
        }
    }

    func searchProfiles(searchString: String, refresh: Bool) {
        self.view?.startFooterLoading()
        self.currentSearchString = searchString
        UserRequest.searchProfiles(searchString: self.currentSearchString,
                                   profilesDownloaded: refresh ? [Profile]() : self.profiles,
                                   pagination: Paginations.friends) { (success, msg, profiles) in
            if success {
                if refresh {
                    self.profiles = [Profile]()
                }
                profiles!.forEach {
                    if $0.objectId != User.current()!.profile?.objectId {
                        self.profiles.append($0)
                    }
                }
                self.view?.reload()

            } else {
                self.view?.showMessage(msg: msg)
            }
            self.view?.finishFooterLoading()

        }
    }
}
