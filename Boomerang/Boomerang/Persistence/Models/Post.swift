//
//  Post.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

enum TypePost: String {
    case have = "Have"
    case need = "Need"
    case donate = "Donate"
}

enum Condition: String {
    case loan = "Loan"
    case exchange = "Exchange"
    case donation = "Donation"
}

class Post: PFObject {
    
    @NSManaged var id: String?
    @NSManaged var type: PostType?
    @NSManaged var author: Profile?
    @NSManaged var title: String?
    @NSManaged var content: String?
    @NSManaged var condition: PostCondition?
    @NSManaged var loanTime: String?
    @NSManaged var sharedAmount: NSNumber?
    @NSManaged var commentAmount: NSNumber?
    @NSManaged var likeAmount: NSNumber?
    @NSManaged var exchangeDescription: String?
    @NSManaged var place: String?
    @NSManaged var isAvailable: Bool
    
    var isFeatured: Bool? = false
    var typePost: TypePost?
    var postCondition: Condition?
    var createdDate: Date?
    var updateDate: Date?
    var relations: [Photo]?
    var countPhotos = 0
    var photosImage = [UIImage]()
    
    var photos: PFRelation<Photo> {
        return self.relation(forKey: PostKeys.photos) as! PFRelation<Photo>
    }
    
    
    override init(){
        super.init()
    }
    
    convenience init(author: Profile, title: String, content: String, loanTime: String?, exchangeDescription: String?, place: String, condition: Condition?, typePost: TypePost) {
        self.init()
        
        self.author = author
        self.title = title
        self.content = content
        self.loanTime = loanTime
        self.place = place
        
        let postTypes = ApplicationState.sharedInstance.postTypes
        let conditions = ApplicationState.sharedInstance.postConditions
    
        for postType in postTypes where postType.type == typePost.rawValue {
            self.type = postType
        }
        
        self.isAvailable = true
        
        if let loanTime = loanTime {
            self.loanTime = loanTime
        }
        
        if let exchangeDescription = exchangeDescription {
            self.exchangeDescription = exchangeDescription
        }
        
        if let condition = condition {
            for cond in conditions where cond.condition == condition.rawValue {
                self.condition = cond
            }
        } else {
            for cond in conditions where cond.condition == Condition.donation.rawValue {
                self.condition = cond
            }
        }
        
    }
    
    convenience init(object: PFObject) {
        self.init()
        setInformationsUserByPFObject(object: object)
    }
    
    func setInformationsUserByPFObject(object: PFObject){
        self.objectId = object.objectId
        self.createdDate = object.createdAt
        self.updateDate = object.updatedAt
        
        if let title = object["title"] as? String {
            self.title = title
        }
        
        if let content = object["content"] as? String {
            self.content = content
        }
        
        if let typeObject = object["type"] as? PostType {
            let postTypes = ApplicationState.sharedInstance.postTypes
            for type in postTypes where type.objectId == typeObject.objectId {
                self.typePost = TypePost(rawValue: type.type!)
            }
        }
        
        if let conditionObject = object["condition"] as? PostCondition {
            let postConditions = ApplicationState.sharedInstance.postConditions
            for condition in postConditions where condition.objectId == conditionObject.objectId {
                self.postCondition = Condition(rawValue: condition.condition!)!
            }
        }
        
        if let isAvailable = object["isAvailable"] as? Bool {
            self.isAvailable = isAvailable
        }
        
        if let author = object["author"] as? Profile {
            self.author = author
        }
        
        if let isFeatured = object["isFeatured"] as? Bool {
            self.isFeatured = isFeatured
        }
    }
}

extension Post: PFSubclassing {
    static func parseClassName() -> String {
        return "Post"
    }
}
