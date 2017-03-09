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
    
    var name: String? = ""
   // var password: String? = ""
    var cpf: String? = ""
    var accessLevel: Int? = 0
    var gender: Int? = 0
    
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var imageFile: PFFile?
    var profileImage: UIImage?
    
    
    convenience init(user: PFUser) {
        self.init()
        
        self.setInformationsUserByPFUser(user: user)
    }
    
    
    func setInformationsUserByPFUser(user: PFUser){
        
        self.objectId = user.objectId
        
        if let firstName = user["firstName"] as? String {
            
            self.firstName = firstName
        }
        
        if let lastName = user["lastName"] as? String {
            
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


