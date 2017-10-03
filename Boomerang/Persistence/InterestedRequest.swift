//
//  InterestedRequest.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 03/10/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class InterestedRequest: NSObject {
    static func getWaitingListCount(by post: Post, completionHandler: @escaping (_ success: Bool, _ msg: String, Int?) -> Void) {
        ParseRequest.queryCountContainedIn(className: "Interested", key: "post", value: [post]) { (success, msg, count) in
            if success {
                completionHandler(true, msg, count)
            } else {
                completionHandler(true, msg, nil)
            }
        }
    }

}
