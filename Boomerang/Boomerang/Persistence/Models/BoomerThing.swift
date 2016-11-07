//
//  BoomerThing.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 07/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class BoomerThing: NSObject {

    var thingPhoto: UIImage!
    var thingDescription: String!
    var profilePhoto: UIImage!
    var profileName: String!
    
    init(thingPhoto: UIImage, thingDescription: String, profilePhoto: UIImage, profileName: String) {
        self.thingPhoto = thingPhoto
        self.thingDescription = thingDescription
        self.profilePhoto = profilePhoto
        self.profileName = profileName
    }
    
}
