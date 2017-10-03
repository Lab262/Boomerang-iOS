//
//  Scheme.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 10/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse


enum StatusSchemeEnum: String {
    case evaluation = "Evaluation"
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
    @NSManaged var status: SchemeStatus?
    @NSManaged var chat: Chat?
    @NSManaged var beenSeen: Bool
    @NSManaged var showNotification: Bool
    @NSManaged var requesterEvaluated: Bool
    @NSManaged var ownerEvaluated: Bool
    @NSManaged var finalizedDate: Date?
    var statusSchemeEnum: StatusSchemeEnum?
    var condition: ConditionEnum?
    var dealer: Profile?
    
    override init(){
        super.init()
    }
        
    func setupEnums() {
        setupStatusScheme()
    }
    
    private func setupStatusScheme() {        
        let allSchemeStatus = ApplicationState.sharedInstance.schemeStatus
        for schemeStatus in allSchemeStatus where schemeStatus.objectId == status?.objectId {
            self.statusSchemeEnum = StatusSchemeEnum(rawValue: schemeStatus.status!)
        }
    }
    
    convenience init (post: Post, requester: Profile, owner: Profile, chat: Chat) {
        self.init()
        
        self.post = post
        self.requester = requester
        self.owner = owner
        self.showNotification = true
        self.beenSeen = false
        //self.chat = chat
        
        
        let statusPost = ApplicationState.sharedInstance.schemeStatus
        
        for status in statusPost where status.status! == StatusSchemeEnum.negotiation.rawValue {
            self.status = status
        }
        
    }
    
//    func setInformationsBy(object: PFObject){
//        self.objectId = object.objectId
//        self.createdDate = object.createdAt
//        
//        if let requester = object["requester"] as? Profile {
//            self.requester = requester             //self.requester = Profile(object: requester)
//        }
//        
//        if let owner = object["owner"] as? Profile {
//             self.owner = owner
//            //self.owner = Profile(object: owner)
//        }
//        
//        if let post = object["post"] as? Post {
//            self.post = Post(object: post)
//        }
////        
////        if let conditionObject = object ["condition"] as? SchemeStatus {
////            let postConditions = ApplicationState.sharedInstance.postConditions
////            for condition in postConditions where condition.objectId == conditionObject.objectId {
////                self.condition = Condition(rawValue: condition.condition!)
////            }
////        }
////        
//        if let statusObject = object ["status"] as? SchemeStatus {
//            let statusPost = ApplicationState.sharedInstance.schemeStatus
//            for status in statusPost where status.objectId == statusObject.objectId {
//                self.statusScheme = StatusScheme(rawValue: status.status!)
//            }
//        }
//        
//        if self.post?.author?.objectId == self.requester?.objectId {
//            self.post?.author = self.requester
//        } else {
//            self.post?.author = self.owner
//        }
//    }
}

extension Scheme: PFSubclassing {
    static func parseClassName() -> String {
        return "Scheme"
    }
}

