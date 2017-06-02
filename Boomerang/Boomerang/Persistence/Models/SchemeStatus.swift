//
//  SchemeStatus.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 09/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class SchemeStatus: PFObject {
    
    @NSManaged var status: String?
    
}

extension SchemeStatus: PFSubclassing {
    static func parseClassName() -> String {
        return "SchemeStatus"
    }
}

