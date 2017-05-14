//
//  PostCondition.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 13/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class PostCondition: PFObject {

    @NSManaged var condition: String?
    
    convenience init(object: PFObject) {
        self.init()
        setInformationsByObject(object: object)
    }
    
    func setInformationsByObject(object: PFObject){
        self.objectId = object.objectId
        if let condition = object["condition"] as? String {
            self.condition = condition
        }
    }
}

extension PostCondition: PFSubclassing {
    static func parseClassName() -> String {
        return "PostCondition"
    }
}
