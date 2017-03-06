//
//  User.swift
//  Boomerang
//
//  Created by Felipe perius on 11/02/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import Foundation
import Parse

class User: PFObject {
    
    var name: String? = ""
    var password: String? = ""
    var cpf: String? = ""
    var accessLevel: Int? = 0
    var gender: Int? = 0
    
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var userName: String?
    @NSManaged var email: String?
    @NSManaged var imageFile: PFFile?
    var profileImage: UIImage?
    
    
    override init() {
        super.init()
        self.setInformationsUserByPFUser()
    }
    
    func setInformationsUserByPFUser(){
        
        if let firstName = PFUser.current()?["firstName"] as? String {
            
            self.firstName = firstName
        }
        
        if let lastName = PFUser.current()?["lastName"] as? String {
            
            self.lastName = lastName
        }
        
        if let userName = PFUser.current()?["username"] as? String {
            
            self.userName = userName
        }
        
        if let email = PFUser.current()?["email"] as? String {
            
            self.email = email
        }
        
         if let imageFile = PFUser.current()?["photo"] as? PFFile {
            
            self.imageFile = imageFile
        }
    }
}

extension User: PFSubclassing {
    
    static func parseClassName() -> String {
        return "User"
    }
}

