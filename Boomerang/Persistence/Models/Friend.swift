//
//  Friend.swift
//  Boomerang
//
//  Created by Felipe perius on 14/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class Friend: PFObject {
    @NSManaged var id: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var middleName: String?
    @NSManaged var email: String?
    @NSManaged var location: String?
    @NSManaged var pictureURL: String?
    @NSManaged var photo: PFFile?
    @NSManaged var imageFile: PFFile?
    
    
    var profileImage: UIImage?
}

extension Friend {
    convenience init?(JSON: [String : Any]) {
          self.init()
      
      
        self.firstName = JSON["name"] as? String
        self.email = JSON["email"] as? String
    
        
        if let picture = JSON["picture"] as? [String: Any],
            let data = picture["data"] as? [String: Any],
            let url = data["url"] as? String {
            self.pictureURL = url
        }
        else {
            self.pictureURL = nil
        }
    }
}


extension Friend: PFSubclassing {
    static func parseClassName() -> String {
        return "Friend"
    }
}
