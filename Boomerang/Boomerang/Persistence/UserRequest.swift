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
    
    
    static func unfollowUser(currentUser:User, otherUser: User, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        var queryParams = [String : Any]()
        queryParams["from"] = currentUser
        queryParams["to"] = otherUser
        
        ParseRequest.deleteObjectFor(className: "Follow", queryParams: queryParams) { (success, msg) in
            if success {
                completionHandler(true, "success")
            } else {
                completionHandler(false, msg)
            }
        }
    }
    
    static func createFollow(currentUser: User, otherUser: User,  completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        let follow = PFObject(className: "Follow")
        
        follow["from"] = ["__type": "Pointer", "className": "_User", "objectId": currentUser.objectId]
        follow["to"] = ["__type": "Pointer", "className": "_User", "objectId": otherUser.objectId]
        
        follow.saveInBackground { (success, error) in
            if error == nil {
                completionHandler(true, "success")
            } else {
                completionHandler(false, error!.localizedDescription)
            }
        }
    }
    
    
    static func getUserCountOf(key: String, className: String, user: User, completionHandler: @escaping (_ success: Bool, _ msg: String, Int?) -> Void) {
        ParseRequest.queryCountEqualToValue(className: className, key: key, value: user) { (success, msg, count) in
            if success {
                completionHandler(true, msg, count)
            } else {
                completionHandler(true, msg, nil)
            }
        }
    }
    
    static func verifyAlreadyFollowingFor(currentUser: User, otherUser: User, completionHandler: @escaping (_ success: Bool, _ msg: String, _ alreadyFollow: Bool) -> ()) {
        
        var queryParams = [String : Any]()
        queryParams["from"] = currentUser
        queryParams["to"] = otherUser
        
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
    

    static func fetchFollowing(pagination: Int, skip: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, [User]?) -> Void) {
        
        var following: [User] = [User]()
        
        var queryParams = [String : Any]()
        queryParams["from"] = PFUser.current()!
        
        ParseRequest.queryEqualToValue(className: "Follow", queryParams: queryParams, includes: ["to"], pagination: pagination, skip: skip) { (success, msg, objects) in
            
            if success {
                for object in objects! {
                    following.append(User(user: object.object(forKey: "to") as! PFUser))
                }
                
                completionHandler(true, "Success", following)
            } else {
                completionHandler(false, msg.debugDescription, nil)
            }
        }
    }
}
