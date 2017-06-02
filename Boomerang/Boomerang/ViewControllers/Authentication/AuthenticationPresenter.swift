//
//  AuthenticationPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 30/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4


protocol AuthenticationDelegate {
    func startLoadingView()
    func finishLoadingView()
    func showMsg(success: Bool, msg: String)
    func showHome()
}

class AuthenticationPresenter: NSObject {
    
    fileprivate var delegate: AuthenticationDelegate?
    
    func setViewDelegate(delegate: AuthenticationDelegate) {
        self.delegate = delegate
    }
    
    func loginFacebook() {
        self.delegate?.startLoadingView()
        UserRequest.facebookLoginUser { (success, msg, user) in
            if success {
                if user!.isNew {
                    self.getFacebookInformations()
                } else {
                    self.setupUserInstallation(user: user as! User)
                    self.getProfileUser()
                }
            } else {
                self.delegate?.showMsg(success: success, msg: msg)
                self.delegate?.finishLoadingView()
            }
        }
    }
    
    private func getProfileUser() {
        UserRequest.getProfileUser { (success, msg) in
            if success {
                self.saveObjects(objects: [PFInstallation.current()!])
            }
        }
    }
    
    private func setupUserInstallation(user: User) {
        PFInstallation.current()?.setObject(user, forKey: InstalationKey.user)
    }
    
    private func saveObjects(objects: [PFObject]) {
        
        ParseRequest.saveAllObjects(objects: objects) { (success, msg) in
            if success {
                self.delegate?.showHome()
            } else {
                self.delegate?.showMsg(success: success, msg: msg)
            }
            self.delegate?.finishLoadingView()
        }
    }
    
    private func createProfileByUser(user: User) -> Profile {
        let profile = Profile()
        profile.firstName = user.firstName
        profile.lastName = user.lastName
        profile.email = user.email
        profile.facebookId = user.username
        profile.photo = user.photo
        user.profile = profile
        
        return profile
    }
    
    private func setupUserInformationsByResult(result: Any) -> User? {
        let user = PFUser.current()! as? User
        
        if let data = result as? [String: Any] {
            
            if let firstName = data[FacebookParams.firstName] as? String {
                user!.setObject(firstName, forKey: UserKeys.firstName)
            }
            
            if let lastName = data[FacebookParams.lastName] as? String {
                user!.setObject(lastName, forKey: UserKeys.lastName)
            }
            
            if let email = data [FacebookParams.email] as? String {
                user!.setObject(email, forKey: UserKeys.email)
            }
            
            if let userId = data[FacebookParams.id] as? String {
                user!.setObject(userId, forKey: UserKeys.userName)
            }
            
            return user!
        }
    
        return nil
    }
    
    private func getFacebookUserPhoto(user: User, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ())  {
        UserRequest.getFacebookUserPhoto(userId: user.username!, completionHandler: { (success, msg, file) in
            if success {
                user.photo = file
                completionHandler(success, msg)
            } else {
                completionHandler(success, "facebook user photo error: \(msg)")
            }
        })
    }
    
    private func getFacebookInformations() {
        UserRequest.requestFacebookParameters { (success, msg, result) in
            if success {
                if let user = self.setupUserInformationsByResult(result: result!) {
                    self.getFacebookUserPhoto(user: user, completionHandler: { (success, msg) in
                        if success {
                            self.setupUserInstallation(user: user)
                            let profile = self.createProfileByUser(user: user)
                            user.profile = profile
                            self.saveObjects(objects: [user, profile, PFInstallation.current()!])
                        } else {
                            self.delegate?.showMsg(success: success, msg: msg)
                            self.delegate?.finishLoadingView()
                        }
                    })
                } else {
                    self.delegate?.showMsg(success: false, msg: "No data in result")
                    self.delegate?.finishLoadingView()
                }
            } else {
                self.delegate?.showMsg(success: success, msg: msg)
                self.delegate?.finishLoadingView()
            }
        }
    }
}

