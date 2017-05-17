//
//  UserRequest.swift
//  Boomerang
//
//  Created by Felipe perius on 07/02/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse


class UserRequest: NSObject {
    
    static func createAccountUser(user: User, pass: String, completionHandler: @escaping (_ success: Bool, _ msg: String) -> Void) {
        
        let pfUser = PFUser()
        
        pfUser.password = pass
        pfUser.email = user.email
        
        pfUser.signUpInBackground { (success, error) in
            if error == nil {
                completionHandler(true, "Sucesso")
            } else {
                
                completionHandler(false, error.debugDescription)
            }
        }
    }
    
    static func getProfileUser(completionHandler: @escaping (_ sucess: Bool, _ msg: String) -> ()) {
      
        let user = PFUser.current()!
        user.fetchObjectInBackgroundBy(key: "profile") { (success, msg, profile) in
            if success {
                completionHandler(success, msg)
            } else {
                completionHandler(success, msg)
            }
        }
    }
    
    static func loginUserWithFacebook(id: String, email: String,userName: String ,mediaType:Int,completionHandler: @escaping (_ sucess: Bool, _ msg: String, _ user: User?) -> Void) {
        
        
    }
    
    static func loginUser(email: String, pass: String, completionHandler: @escaping (_ success: Bool, _ msg: String) -> Void) {
        
        PFUser.logInWithUsername(inBackground: email, password: pass) { (success, error) in
            
            if error == nil {
                completionHandler(true, "Sucesso")
            } else {
                completionHandler(false, error.debugDescription)
            }
        }
    }
    
    
    static func getUserCountOfDictionary(keysCount: [String: [String]], user: User, completionHandler: @escaping (_ success: Bool, _ msg: String, Int?) -> Void) {
        
        
    }
    
    func getUserImage(profile: Profile, imageView: UIImageView, completionHandler: @escaping (_ success: Bool, _ msg: String, _ image: UIImage?) -> Void) {
        
        guard let image = profile.profileImage else {
            imageView.loadAnimation()
            profile.getDataInBackgroundBy(key: #keyPath(User.photo), completionHandler: { (success, msg, data) in
                if success {
                    completionHandler(true, "Success", UIImage(data: data!)!)
                } else {
                    completionHandler(false, msg, nil)
                }
                imageView.unload()
            })
            return
        }
        completionHandler(true, "Success", image)
    }
    
    
    static func unfollowUser(currentProfile: Profile, otherProfile: Profile, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        var queryParams = [String : Any]()
        queryParams["from"] = currentProfile
        queryParams["to"] = otherProfile
        
        ParseRequest.deleteObjectFor(className: "Follow", queryParams: queryParams) { (success, msg) in
            if success {
                completionHandler(true, "success")
            } else {
                completionHandler(false, msg)
            }
        }
    }
    
    static func createFollow(currentProfile: Profile, otherProfile: Profile,  completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
//        let follow = PFObject(className: "Follow")
//        
//        follow["from"] = ["__type": "Pointer", "className": "_User", "objectId": currentUser.objectId]
//        follow["to"] = ["__type": "Pointer", "className": "_User", "objectId": otherUser.objectId]
//        
//        follow.saveInBackground { (success, error) in
//            if error == nil {
//                completionHandler(true, "success")
//            } else {
//                completionHandler(false, error!.localizedDescription)
//            }
//        }
    }
    
    
    static func getProfileCountOf(key: String, className: String, profile: Profile, completionHandler: @escaping (_ success: Bool, _ msg: String, Int?) -> Void) {
        
        ParseRequest.queryCountEqualToValue(className: className, key: key, value: profile) { (success, msg, count) in
            if success {
                completionHandler(true, msg, count)
            } else {
                completionHandler(true, msg, nil)
            }
        }
    }
    
    static func verifyAlreadyFollowingFor(currentProfile: Profile, otherProfile: Profile, completionHandler: @escaping (_ success: Bool, _ msg: String, _ alreadyFollow: Bool) -> ()) {
        
        var queryParams = [String : Any]()
        queryParams["from"] = currentProfile
        queryParams["to"] = otherProfile
        
        ParseRequest.queryEqualToValue(className: "Follow", queryParams: queryParams, includes: nil) { (success, msg, objects) in
            if success {
                if objects!.count > 0 {
                    completionHandler(true, "Success", true)
                } else {
                    completionHandler(true, msg, false)
                }
            }
        }
    }
    
    

    static func fetchFollowing(fromProfile: Profile, followingDownloaded: [Profile], pagination: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, [Profile]?) -> Void) {
        
        var following: [Profile] = [Profile]()
        var queryParams = ["from" : [fromProfile]]
    
        var notContainedObjectIds = [String]()
        
        followingDownloaded.forEach{
            notContainedObjectIds.append($0.objectId!)
        }
        
        let notContainedObjects = ["objectId": notContainedObjectIds]
        
        
        ParseRequest.queryEqualToValueNotContainedObjects(className: "Follow", queryType: .common, params: queryParams, notContainedObjects: notContainedObjects, includes: ["to"], pagination: pagination) { (success, msg, objects) in
            if success {
                for object in objects! {
                    following.append(Profile(object: object.object(forKey: "to") as! PFObject))
                }
                completionHandler(true, "Success", following)
            } else {
                completionHandler(false, msg.debugDescription, nil)
            }
        }
    }
}
