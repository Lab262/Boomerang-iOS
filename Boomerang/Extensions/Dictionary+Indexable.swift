//
//  Dictionary+Indexable.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 07/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

extension Dictionary {
    
    func keyAtIndex(index: Int) -> String {
        return Array(self.keys)[index] as! String
    }

    func dataAtKeyAtIndex(index: Int) -> AnyObject{
        let key = Array(self.keys)[index]
        return   self[key] as AnyObject
    }
}
