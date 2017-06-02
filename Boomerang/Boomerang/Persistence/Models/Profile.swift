//
//  Profile.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 30/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Foundation
import Parse


class Profile: PFObject {
    
    @NSManaged var facebookId: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var email: String?
    @NSManaged var photo: PFFile?
    var pictureURL: String?
    var profileImage: UIImage?
    var alreadySearched = false
    var follow: Follow?
    var alreadyFollow: Bool?
    
    
    override init() {
        super.init()
    }
    
    var fullName: String {
        if case let (firstName?, lastName?) = (firstName, lastName) {
            return "\(firstName) \(lastName)"
        } else {
            return ""
        }
    }    
}

extension Profile: PFSubclassing {
    static func parseClassName() -> String {
        return "Profile"
    }
}


