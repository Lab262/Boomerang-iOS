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
    case progress = "Progress"
    case done = "Done"
    case canceled = "Canceled"
    case negotiation = "Negotiation"
    case finished = "Finished"
}

class Scheme: PFObject {
    
    @NSManaged var post: Post?
    @NSManaged var requester: Profile?
    @NSManaged var owner: Profile?
    @NSManaged var chat: Chat?
    var status: StatusScheme?
    var createdDate: Date?
    var dealer: Profile?
    
    override init(){
        super.init()
    }
    
    convenience init(object: PFObject) {
        self.init()
        
        self.setInformationsBy(object: object)
    }
    
    convenience init (post: Post, requester: Profile, owner: Profile, chat: Chat) {
        self.init()
        
        self.post = post
        self.requester = requester
        self.owner = owner
        self.chat = chat
    }
    
    func setInformationsBy(object: PFObject){
        self.objectId = object.objectId
        self.createdDate = object.createdAt
        
        if let requester = object["requester"] as? Profile {
            self.requester = Profile(object: requester)
        }
        
        if let owner = object["owner"] as? Profile {
            self.owner = Profile(object: owner)
        }
        
        if let post = object["post"] as? Post {
            self.post = Post(object: post)
        }
        
        if let statusObject = object ["status"] as? SchemeStatus {
            let statusPost = ApplicationState.sharedInstance.schemeStatus
            for status in statusPost where status.objectId == statusObject.objectId {
                self.status = StatusScheme(rawValue: status.status!)
            }
        }
        
        if self.post?.author?.objectId == self.requester?.objectId {
            self.post?.author = self.requester
        } else {
            self.post?.author = self.owner
        }
    }
}

extension Scheme: PFSubclassing {
    static func parseClassName() -> String {
        return "Scheme"
    }
}

