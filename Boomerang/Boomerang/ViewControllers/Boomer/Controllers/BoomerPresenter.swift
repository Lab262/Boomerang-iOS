//
//  BoomerPresenter.swift
//  Boomerang
//
//  Created by Felipe perius on 09/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import UIKit
import Parse

class BoomerPresenter: NSObject {
    fileprivate var user: User = ApplicationState.sharedInstance.currentUser!
   
    
    func getUserImage(completionHandler: @escaping (_ success: Bool, _ msg: String, _ image: UIImage?) -> Void) {
        guard let image = user.profileImage else {
            user.getDataInBackgroundBy(key: #keyPath(User.photo), completionHandler: { (success, msg, data) in
                
                if success {
                    completionHandler(true, "Success", UIImage(data: data!)!)
                } else {
                    completionHandler(false, msg, nil)
                }
            })
            return
        }
        completionHandler(true, "Success", image)
    }

}
