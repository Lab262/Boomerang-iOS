//
//  PostRequest.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 19/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class PromoCodeRequest: NSObject {
    
    let userDefaults = UserDefaults.standard
    
    static func checkValidity(code: String, completionHandler: @escaping (_ success: Bool, _ msg: String, _ isValid: Bool, _ promoCodeId: String) -> Void) {
        
        var params = [String: String]()
        
        params["promoCode"] = code
        
        PFCloud.callFunction(inBackground: CloudFunctions.validatePromoCode, withParameters: params) { (objects, error) in
            if let _ = error {
                completionHandler(false, error!.localizedDescription, false, "")
            } else {
                if let response = objects as? [String: AnyObject],
                    let isValid = response["isValid"] as? Bool,
                    let promoCodeId = response["promoCode"]?.objectId as? String {
                    if isValid {
                        completionHandler(true, "success", true, promoCodeId)
                    } else {
                        let message = response["msg"] as? String
                        completionHandler(true, message!, false, "")
                    }
                } else {
                    completionHandler(false, "", false, "")
                }
            }
        }
    }
    
    static func registerCode(code: String, completionHandler: @escaping (_ success: Bool, _ msg: String) -> Void) {
        
        var params = [String: String]()
        
        params["promoCode"] = code
        params["user"] = PFUser.current()?.objectId

        PFCloud.callFunction(inBackground: CloudFunctions.registerPromoCode, withParameters: params) { (objects, error) in
            if let _ = error {
                completionHandler(false, error!.localizedDescription)
            } else {
                completionHandler(true,"")
            }
        }
    }
    
}
