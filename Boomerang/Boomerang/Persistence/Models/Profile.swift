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
    
    convenience init(object: PFObject) {
        self.init()
        
        setInformationsByObject(object: object)
    }
    
    func setInformationsByObject(object: PFObject){
        
        self.objectId = object.objectId
        
        if let firstName = object["firstName"] as? String {
            self.firstName = firstName
        }
        
        if let lastName = object["lastName"] as? String {
            self.lastName = lastName
        }
        
        if let email = object["email"] as? String {
            self.email = email
        }
        
        if let photo = object["photo"] as? PFFile {
            self.photo = photo
        }
    }
}

extension Profile: PFSubclassing {
    static func parseClassName() -> String {
        return "Profile"
    }
}


