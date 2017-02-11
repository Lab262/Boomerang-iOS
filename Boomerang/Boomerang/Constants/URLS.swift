//
//  URLS.swift
//  Boomerang
//
//  Created by Felipe perius on 11/02/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import FalconFrameworkIOSSDK

#if DEVELOPMENT
let URL_WS_SERVER = "https://boomerang-api-stg.herokuapp.com/api"
#else
let URL_WS_SERVER = "https://boomerang-api-prd.herokuapp.com/api"
#endif
class URLS: NSObject {
    static func setupBaseURL() {
        FFDefaults.hostBaseURL = URL_WS_SERVER
    }

}
