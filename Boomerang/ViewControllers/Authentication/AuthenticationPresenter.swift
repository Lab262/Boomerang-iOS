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
    func showPromoCode()
    func reload()
}

class AuthenticationPresenter: NSObject {
    
    fileprivate var delegate: AuthenticationDelegate?
    
    var onboardData: [[String:Any]] = [[String:Any]]() {
        didSet {
            self.delegate?.reload()
        }
    }
    
    func setViewDelegate(delegate: AuthenticationDelegate) {
        self.delegate = delegate
    }
    
    func loginFacebook() {
        self.delegate?.startLoadingView()
        UserRequest.facebookLoginUser { (success, msg, user, isWithValidPromoCode) in
            if success {
                //Comment to Remove promo code 
//                if user!.isNew || !isWithValidPromoCode! {
//                    self.delegate?.showPromoCode()
//                }
                if user!.isNew {
                    self.delegate?.startLoadingView()
                   self.getFacebookInformations()
                }
                else {
                    self.setupUserInstallation(user: user as! User)
                    self.getProfileUser()
                }
            } else {
                self.delegate?.showMsg(success: success, msg: msg)
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
    
    func getFacebookInformations() {
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
    
    private func requestAllPostTypes(completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        PostRequest.getAllTypes { (success, msg) in
            completionHandler(success, msg)
        }
    }
    
    private func requestAllPostConditions(completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        PostRequest.getAllConditions { (success, msg) in
            completionHandler(success, msg)
        }
    }
    
    private func requestSchemeStatus(completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        SchemeRequest.getAllStatus { (success, msg) in
            completionHandler(success, msg)
        }
    }
    
    func requestInformationsProfileUser(completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        self.requestAllPostTypes(completionHandler: { (success, msg) in
            if success {
                self.requestAllPostConditions(completionHandler: { (success, msg) in
                    if success {
                        self.requestSchemeStatus(completionHandler: { (success, msg) in
                            completionHandler(success,msg)
                            return
                        })
                    }else{
                        completionHandler(success,msg)
                        return
                    }
                })
            }else{
                completionHandler(success,msg)
                return
            }
        })
    }
    
    func setOnboardData() {
        
        let firstData = setDictOnboardData(image: OnboardLoginCellImages.firstCell, text: OnboardLoginCellStrings.firstCell)
        let secondData = setDictOnboardData(image: OnboardLoginCellImages.secondCell, text: OnboardLoginCellStrings.secondCell)
        let thirdData = setDictOnboardData(image: OnboardLoginCellImages.thirdCell, text: OnboardLoginCellStrings.thirdCell)
        
        self.onboardData.append(contentsOf: [firstData,secondData,thirdData])
    }
    
    private func setDictOnboardData(image: UIImage, text: String) -> [String:Any] {
        
        var dictOnboardData = [String:Any]()
        
        dictOnboardData[OnboardCellKeys.keyImageView] = image
        dictOnboardData[OnboardCellKeys.keyDescriptionLabel] = text
        
        return dictOnboardData
    }
}

