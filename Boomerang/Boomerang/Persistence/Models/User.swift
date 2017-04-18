//
//  User.swift
//  Boomerang
//
//  Created by Felipe perius on 11/02/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import Foundation
import Parse

class User: PFUser {
    
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var imageFile: PFFile?
    var fullName: String?
    var profileImage: UIImage?
    var alreadySearched = false
    var follow: Follow?

    convenience init(user: PFUser) {
        self.init()
        
        setInformationsUserByPFUser(user: user)
    }
    
    func setInformationsUserByPFUser(user: PFUser){
        
        self.objectId = user.objectId
        
        if let firstName = user["firstName"] as? String {
            self.fullName = firstName
            self.firstName = firstName
        }
        
        if let lastName = user["lastName"] as? String {
            self.fullName?.append(" \(lastName)")
            self.lastName = lastName
        }
        
        if let email = user["email"] as? String {
            self.email = email
        }
        
        if let imageFile = user["photo"] as? PFFile {
            
            self.imageFile = imageFile
        }
    }
}


