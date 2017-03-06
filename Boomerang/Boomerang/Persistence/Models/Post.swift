//
//  Post.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class Post: PFObject {
    
    @NSManaged var id: String?
    @NSManaged var author: User?
    @NSManaged var title: String?
    @NSManaged var content: String?
    @NSManaged var thing: Thing?
    
    
    override init(){
        super.init()
    }
    
//    override class func initialize() {
//        self.registerSubclass()
//    }
    
    convenience init(object: PFObject) {
        self.init()
        
        setInformationsUserByPFObject(object: object)
    }
    
    
    func setInformationsUserByPFObject(object: PFObject){
        
        self.objectId = object.objectId
        
        if let title = object["title"] as? String {
            
            self.title = title
        }
        
        if let content = object["content"] as? String {
            
            self.content = content
        }
        
        if let author = object["author"] as? User {
            
            self.author = author
        }
        
        if let thing = object["thing"] as? Thing {
            
            self.thing = thing
        }
       
    }
}

extension Post: PFSubclassing {
    static func parseClassName() -> String {
        return "Post"
    }
}
