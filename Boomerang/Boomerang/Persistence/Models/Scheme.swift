//
//  Scheme.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 10/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse


enum StatusScheme: String {
    case progress
    case done
    case canceled
}

class Scheme: PFObject {
    
    @NSManaged var post: Post?
    @NSManaged var requester: User?
    @NSManaged var owner: User?
    @NSManaged var chat: Chat?
    @NSManaged var status: String?
    
}

extension Scheme: PFSubclassing {
    static func parseClassName() -> String {
        return "Scheme"
    }
}

