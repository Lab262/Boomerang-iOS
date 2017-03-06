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
        
        pfUser.username = user.name
        pfUser.password = pass
        pfUser.email = user.email
        pfUser["emailVerified"] = false
        
        
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
    
    static func getProfilePhoto(user: User, completionHandler: @escaping (_ success: Bool, _ msg: String, _ photo: UIImage?) -> Void) {
        
        user.imageFile?.getDataInBackground(block: { (data, error) in
            
            if error == nil {
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    completionHandler(true, "Success", image)
                } else {
                    completionHandler(false, "data is nil", nil)
                }
            } else {
                completionHandler(false, error.debugDescription, nil)
            }
        })
    }
    
    static func getThingPhoto(thing: Thing, completionHandler: @escaping (_ success: Bool, _ msg: String, _ photo: UIImage?) -> Void) {
        
        thing.image?.getDataInBackground(block: { (data, error) in
            
            if error == nil {
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    completionHandler(true, "Success", image)
                } else {
                    completionHandler(false, "data is nil", nil)
                }
            } else {
                completionHandler(false, error.debugDescription, nil)
            }
        })
    }

}
