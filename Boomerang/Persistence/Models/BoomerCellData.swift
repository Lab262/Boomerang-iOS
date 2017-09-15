//
//  BoomerCellData.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 09/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class BoomerCellData: NSObject {
    
    var dataPhoto: UIImage!
    var dataDescription: String!
    var dataTitle: String!
    var dataSubDescription: String?
   
    
    init(dataPhoto: UIImage,
         dataDescription: String,
         dataTitle: String,
         dataSubDescription: String? = nil) {
        self.dataPhoto = dataPhoto
        self.dataDescription = dataDescription
        self.dataTitle = dataTitle
        self.dataSubDescription = dataSubDescription
    }
}
