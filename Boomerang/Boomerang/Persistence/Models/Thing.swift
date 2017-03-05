//
//  Thing.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class Thing: PFObject {
    
    @NSManaged var name: String?
    @NSManaged var descriptionThing: String?
    @NSManaged var images: [PFFile]?

}

extension Thing: PFSubclassing {
    static func parseClassName() -> String {
        return "Thing"
    }
}
