//
//  Evaluation.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 20/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class Evaluation: PFObject {
    
    @NSManaged var scheme: Scheme?
    @NSManaged var comment: String?
    @NSManaged var amountStars: NSNumber?
    @NSManaged var owner: Profile?
    @NSManaged var requester: Profile?
    var createdDate: Date?
    
    override init(){
        super.init()
    }
    
    
    convenience init(scheme: Scheme, comment: String, amountStars: NSNumber) {
        self.init()
        self.scheme = scheme
        self.owner = scheme.owner
        self.requester = scheme.requester
        self.comment = comment
        self.amountStars = amountStars
    }
    
    convenience init(object: PFObject) {
        self.init()
        self.setInformationsBy(object: object)
    }
    
    func setInformationsBy(object: PFObject){
        
        self.objectId = object.objectId
        self.createdDate = object.createdAt
        
        if let amountStars = object["amountStars"] as? NSNumber {
            self.amountStars = amountStars
        }
    }
}

extension Evaluation: PFSubclassing {
    static func parseClassName() -> String {
        return "Evaluation"
    }
}
