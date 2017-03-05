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
    
    @NSManaged var firstName: Post?
    @NSManaged var lastName: String?
    @NSManaged var email: String?
    @NSManaged var photo: PFFile?
    
}

extension User: PFSubclassing {
    static func parseClassName() -> String {
        return "User"
    }
}

