//
//  ApplicationState.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 05/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery


enum UpdateType {
    case amount
    case relation
    case download
}

protocol UpdatePostDelegate {
    func updateRelationsPost(post: Post?, success: Bool, updateType: UpdateType)
}


class ApplicationState: NSObject {
    
    var delegate: UpdatePostDelegate?
    
    let liveQueryClient = ParseLiveQuery.Client(server: AppConfig.parse.baseClientConfig.server, applicationId: AppConfig.parse.baseClientConfig.applicationId, clientKey: AppConfig.parse.baseClientConfig.clientKey)
    
    var currentPost: Post? {
        didSet{
            
        }
    }
    
    var schemeStatus = [SchemeStatus]()
    var postTypes = [PostType]()
    var postConditions = [PostCondition]()
    
    
    
//    var currentUser: User? {
//        didSet {
//            
//        }
//    }
    
    func callDelegateUpdate(post: Post?, success: Bool, updateType: UpdateType){
        ApplicationState.sharedInstance.delegate?.updateRelationsPost(post: post, success: success, updateType: updateType)
    }
    
    static let sharedInstance : ApplicationState = {
        let instance = ApplicationState(singleton: true)
        return instance
    }()
    
    
    
    private init(singleton: Bool) {
        super.init()
        //self.currentUser = PFUser.current() as? User
    }
}
