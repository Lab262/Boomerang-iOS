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

    var createdDate: Date?
    var dealer: User?
    
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
        
        
        if let requester = object["requester"] as? User {
            self.requester = User(user: requester)
        }
        
        //if let owner = object["owner"] as? User {
          //  self.owner = User(user: owner)
       // }
        
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

