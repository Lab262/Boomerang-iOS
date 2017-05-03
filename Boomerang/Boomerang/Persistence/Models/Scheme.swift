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
    @NSManaged var requester: Profile?
    @NSManaged var owner: Profile?
    @NSManaged var chat: Chat?
    @NSManaged var status: String?

    var createdDate: Date?
    var dealer: Profile?
    
    override init(){
        super.init()
    }
    
    convenience init(object: PFObject) {
        self.init()
        
        self.setInformationsBy(object: object)
    }
    
    func setInformationsBy(object: PFObject){
        
        self.objectId = object.objectId
        self.createdDate = object.createdAt
        
        
        if let requester = object["requester"] as? Profile {
            self.requester = Profile(object: requester)
        }
        
        if let owner = object["owner"] as? User {
            self.owner = Profile(object: owner)
        }
        
        if let post = object["post"] as? Post {
            self.post = Post(object: post)
        }
        
//        if let chat = object["chat"] as? Chat {
//            self.chat = Chat(object: chat)
//        }
    }
}

extension Scheme: PFSubclassing {
    static func parseClassName() -> String {
        return "Scheme"
    }
}

