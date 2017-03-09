//
//  BoomerThing.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 07/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import Parse

class BoomerThing: NSObject {
    
    enum thingType: Int {
        case have, need, donate, experience
    }
    
    var post: Post?
//    var thingDescription: String?
//    var profilePhoto: PFFile?
//    var profileName: String?
    var thingType: thingType?
    
    init (post: Post, thingType: thingType) {
        self.post = post
        self.thingType = thingType
    }
//    init(thingPhoto: PFFile, thingDescription: String, profilePhoto: PFFile, profileName: String, thingType: thingType) {
//        self.thingPhoto = thingPhoto
//        self.thingDescription = thingDescription
//        self.profilePhoto = profilePhoto
//        self.profileName = profileName
//        self.thingType = thingType
//    }
    
}
