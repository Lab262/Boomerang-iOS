//
//  Post.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

enum postType: String {
    case have = "Have"
    case need = "Need"
    case donate = "Donate"
}

class Post: PFObject {
    
    @NSManaged var id: String?
    @NSManaged var type: String?
    @NSManaged var author: User?
    @NSManaged var title: String?
    @NSManaged var content: String?
    @NSManaged var thing: Thing?
    @NSManaged var createdDate: Date?
    @NSManaged var relations: [Photo]?
    
    var alreadySearched = false
    var downloadedImages = false
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
