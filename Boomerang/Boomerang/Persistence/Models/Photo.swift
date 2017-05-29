//
//  Photo.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 29/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class Photo: PFObject {
    
    @NSManaged var imageFile: PFFile?
    var photo: UIImage?
    var isDownloadedImage = false
    
    convenience init(object: PFObject) {
        self.init()
        setInformationsUserByPFObject(object: object)
    }

    func setInformationsUserByPFObject(object: PFObject){
        self.objectId = object.objectId
        
        if let imageFile = object["imageFile"] as? PFFile {
            self.imageFile = imageFile
        }
    }

}


extension Photo: PFSubclassing {
    static func parseClassName() -> String {
        return "Photo"
    }
}
