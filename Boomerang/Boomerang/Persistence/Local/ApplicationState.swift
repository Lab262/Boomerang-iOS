//
//  ApplicationState.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class ApplicationState: NSObject {
    
    var currentUser: User? {
        didSet {
            
        }
    }
    
    
    static let sharedInstance : ApplicationState = {
        let instance = ApplicationState(singleton: true)
        return instance
    }()
    
    
    
    private init(singleton: Bool) {
        super.init()
        self.currentUser = User(user: PFUser.current()!)
    }
}
