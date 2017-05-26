//
//  AddBoomerPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 25/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4

protocol AddBoomerDelegate {
    func loadingView()
    func unloadView()
    func showMessage(msg: String)
    func reload()
}

class AddBoomerPresenter: NSObject {
    
    fileprivate var facebookIds: [String] = [String]()
    var profiles: [Profile] = [Profile]()
    private var view: AddBoomerDelegate?
    private var pagination: Int = Paginations.facebookFriends
    
    func setViewDelegate(view: AddBoomerDelegate){
        self.view = view
    }
    
    func getFriendsByFacebook(){
        self.view?.loadingView()
        let requestParameters = ["fields":"id, name, installed"]
        let userDetails = FBSDKGraphRequest(graphPath: "/me/friends?fields=installed", parameters: requestParameters)
        userDetails!.start { (connection, result, error) -> Void in
            if error != nil {
                print(error.debugDescription)
                self.view?.showMessage(msg: error.debugDescription)
                self.view?.unloadView()
            }else {
                if let data = result as? [String: Any] {
                    if let data = data["data"] as? [[String: Any]] {
                        for userData:[String: Any] in data {
                            if let id = userData["id"] as? String {
                                self.facebookIds.append(id)
                            }
                        }
                        self.getFacebookUsers()
                    }
                }
            }
        }
    }

    
    private func getFacebookUsers() {
        UserRequest.getProfileByFacebookIds(facebookIds: self.facebookIds, friendsDownloaded: profiles, pagination: Paginations.facebookFriends) { (success, msg, profiles) in
            if success {
                profiles!.forEach {
                    self.profiles.append($0)
                }
                self.view?.reload()
                
            } else {
                self.view?.showMessage(msg: msg)
            }
            self.view?.unloadView()
        }
    }
}
