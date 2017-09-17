//
//  ProfileRequest.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 30/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse


class ProfileRequest: NSObject {
    
    static func getAverageStars(profile: Profile, completionHandler: @escaping (_ success: Bool, _ msg: String, _ averageStars: Int) -> ()) {
        
        var params = [String : String]()
        
        params["profileId"] = profile.objectId
        
        PFCloud.callFunction(inBackground: CloudFunctions.averageStars, withParameters: params) { (objects, error) in
            if let _ = error {
                completionHandler(false, error!.localizedDescription, 0)
            } else {
                if let stars = objects as? Int {
                   completionHandler(true, "success", stars)
                }
            }
        }
    }
    
    

}
