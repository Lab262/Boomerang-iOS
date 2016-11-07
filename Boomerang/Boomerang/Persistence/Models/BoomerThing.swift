//
//  BoomerThing.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 07/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class BoomerThing: NSObject {
    
    enum thingType: Int {
        case have, need, donate, experience
    }
    
    var thingPhoto: UIImage!
    var thingDescription: String!
    var profilePhoto: UIImage!
    var profileName: String!
    var thingType: thingType!
    
    init(thingPhoto: UIImage, thingDescription: String, profilePhoto: UIImage, profileName: String, thingType: thingType) {
        self.thingPhoto = thingPhoto
        self.thingDescription = thingDescription
        self.profilePhoto = profilePhoto
        self.profileName = profileName
        self.thingType = thingType
    }
    
}
