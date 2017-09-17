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
    @NSManaged var evaluated: Profile?
    @NSManaged var appraiser: Profile?
    
    override init(){
        super.init()
    }
    
    convenience init(scheme: Scheme, comment: String, evaluated: Profile, appraiser: Profile, amountStars: NSNumber) {
        self.init()
        self.scheme = scheme
        self.evaluated = evaluated
        self.appraiser = appraiser
        self.comment = comment
        self.amountStars = amountStars
    }

}

extension Evaluation: PFSubclassing {
    static func parseClassName() -> String {
        return "Evaluation"
    }
}
