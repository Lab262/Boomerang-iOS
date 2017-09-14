//
//  Post.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

enum TypePostEnum: String {
    case have = "Have"
    case need = "Need"
    case donate = "Donate"
}

enum ConditionEnum: String {
    case loan = "Loan"
    case exchange = "Exchange"
    case donation = "Donation"
}

class Post: PFObject {
    
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
    var typePostEnum: TypePostEnum?
    var postConditionEnum: ConditionEnum?
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
    
    func queryPhotos(completionHandler: (([Photo]?) -> ())? = nil) {
        if self.relations == nil {
            photos.query().findObjectsInBackground { (photos, error) in
                if let photos = photos {
                    self.relations = photos
                }
                completionHandler?(photos)
            }
        } else {
            completionHandler?(self.relations)
        }
    }
    
    func setupEnums() {
        setupPostCondition()
        setupPostTypes()
    }
    
    private func setupPostCondition() {
        let postConditions = ApplicationState.sharedInstance.postConditions
        for postCondition in postConditions where postCondition.objectId == condition?.objectId {
            self.postConditionEnum = ConditionEnum(rawValue: postCondition.condition!)
        }
    }
    
    private func setupPostTypes() {
        let postTypes = ApplicationState.sharedInstance.postTypes
        for postType in postTypes where postType.objectId == type?.objectId {
            self.typePostEnum = TypePostEnum(rawValue: postType.type!)
        }
    }
    
    convenience init(author: Profile, title: String, content: String, loanTime: String?, exchangeDescription: String?, place: String, condition: ConditionEnum?, typePost: TypePostEnum) {
        
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
            for cond in conditions where cond.condition == ConditionEnum.donation.rawValue {
                self.condition = cond
            }
        }
    }
}

extension Post: PFSubclassing {
    static func parseClassName() -> String {
        return "Post"
    }
}
