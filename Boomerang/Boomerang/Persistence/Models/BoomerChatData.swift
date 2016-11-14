//
//  BoomerChatData.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 14/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class BoomerChatData: NSObject {

    var friendPhotos: [UIImage]?
    var friendNames: [String]?
    var messages = [MessageModel]()
    
    init(friendPhotos: [UIImage]? = nil,
         friendNames: [String]? = nil) {
        
        self.friendPhotos = friendPhotos
        self.friendNames = friendNames
    }
    
}

class MessageModel: NSObject {
    
    var content: String!
    var postDateInterval: TimeInterval!
    var boomerSender: String!
    
    init(content: String,
         postDateInterval: TimeInterval,
         boomerSender: String) {
        
        self.content = content
        self.postDateInterval = postDateInterval
        self.boomerSender = boomerSender
    }
}
