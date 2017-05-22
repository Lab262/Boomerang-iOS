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
    @NSManaged var type: String?
    @NSManaged var author: Profile?
    @NSManaged var title: String?
    @NSManaged var content: String?
    var isFeatured: Bool? = false
    var typePost: TypePost?
    var condition: Condition?
    var createdDate: Date?
    var updateDate: Date?
    var relations: [Photo]?
    var countPhotos = 0
    var photos = [UIImage]()
    
    
    override init(){
        super.init()
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
                self.condition = Condition(rawValue: condition.condition!)
            }
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
