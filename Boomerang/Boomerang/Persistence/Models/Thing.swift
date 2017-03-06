//
//  Thing.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class Thing: PFObject {
    
    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var descriptionThing: String?
    @NSManaged var image: PFFile?
    @NSManaged var images: [PFFile]?
    
    override init(){
        super.init()
    }
    
    convenience init(object: PFObject) {
        self.init()
        
        setInformationsUserByPFObject(object: object)
    }
    
    
    func setInformationsUserByPFObject(object: PFObject){
        
        self.id = object.objectId
        
        if let name = object["name"] as? String {
            
            self.name = name
        }
        
        if let descriptionThing = object["description"] as? String {
            
            self.descriptionThing = descriptionThing
        }
        
        if let image = object["image"] as? PFFile {
            
            self.image = image
        }
        
    }

}

extension Thing: PFSubclassing {
    static func parseClassName() -> String {
        return "Thing"
    }
}
