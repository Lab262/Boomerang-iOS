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
    @NSManaged var photo: PFFile?
    @NSManaged var profile: Profile?
    var fullName: String?
    var profileImage: UIImage?
    var alreadySearched = false
    var follow: Follow?
    
    
//    static var current: User? {
//        return PFUser.current() as? User
//    }
    
    override init() {
        super.init()
    }
    

//    convenience init(user: PFUser) {
//        self.init()
//
//        setInformationsUserByPFUser(user: user)
//    }
//    
//    func setInformationsUserByPFUser(user: PFUser){
//        
//        self.objectId = user.objectId
//        
//        if let firstName = user["firstName"] as? String {
//            self.fullName = firstName
//            self.firstName = firstName
//        }
//        
//        if let lastName = user["lastName"] as? String {
//            self.fullName?.append(" \(lastName)")
//            self.lastName = lastName
//        }
//        
//        if let email = user["email"] as? String {
//            self.email = email
//        }
//        
//        if let photo = user["photo"] as? PFFile {
//            self.photo = photo
//        }
//        
//        if let profile = user["profile"] as? Profile {
//            self.profile = profile
//        }
//    }
}


