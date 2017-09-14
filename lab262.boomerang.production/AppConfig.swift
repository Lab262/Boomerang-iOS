//
//  AppConfig.swift
//  SocialNetwork55Lab
//
//  Created by Thiago-Bernardes on 17-04-20.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class AppConfig: NSObject {
    
    struct parse {
        static let baseClientConfig = ParseClientConfiguration {
            $0.applicationId = "api-boomerang-prd"
            $0.clientKey = ""
            $0.server = "http://api-boomerang-prd.herokuapp.com/parse"
        }
        
//        static let baseClientConfig = ParseClientConfiguration { //local parse server dev
//            $0.applicationId = "myAppId"
//            $0.clientKey = ""
//            $0.server = "http://192.168.15.2:1337/parse"
//        }
    }
    
}
