//
//  Comment.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class Comment: PFObject {
    
    @NSManaged var post: Post?
    @NSManaged var content: String?
    @NSManaged var author: Profile?
    @NSManaged var createdDate: Date?
    
    override init(){
        super.init()
    }
    
    init(post: Post, content: String, author: Profile) {
        super.init()
        self.post = post
        self.content = content
        self.author = author
    }
    
    convenience init(object: PFObject) {
        self.init()
        setInformationsUserByPFObject(object: object)
    }
    
    func setInformationsUserByPFObject(object: PFObject){
        self.objectId = object.objectId
        self.createdDate = object.createdAt
        
        if let content = object["content"] as? String {
            self.content = content
        }
        
        if let author = object["author"] as? Profile {
            self.author = Profile(object: author)
        }
        
    }
}

extension Comment: PFSubclassing {
    static func parseClassName() -> String {
        return "Comment"
    }
}

