//
//  RecommendedRequest.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 16/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class RecommendedRequest: NSObject {
    
    static func fetchRecommendations(sender: Profile, post: Post, receivers: [Profile]?, pagination: Int, recommendationsDownloaded: [Recommended]?, completionHandler: @escaping (_ success: Bool, _ msg: String, _ recommendations: [Recommended]?) -> ()) {
        
        var recommendations: [Recommended] = [Recommended]()
        var notContainedObjectIds = [String]()
        
        if let recommendationsDownloaded = recommendationsDownloaded {
            recommendationsDownloaded.forEach {
                notContainedObjectIds.append($0.objectId!)
            }
        }
        
        let query = PFQuery(className: Recommended.parseClassName())
        query.limit = pagination
        query.order(byDescending: ObjectKeys.createdAt)
        query.whereKey(RecommendedKeys.sender, equalTo: sender)
        query.whereKey(RecommendedKeys.post, equalTo: post)
        
        if let receivers = receivers {
             query.whereKey(RecommendedKeys.receiver, containedIn: receivers)
        }
        
        query.whereKey(ObjectKeys.objectId, notContainedIn: notContainedObjectIds)
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        if let recommended = object as? Recommended {
                            recommendations.append(recommended)
                        }
                    }
                }
                completionHandler(true, "success", recommendations)
            } else {
                completionHandler(false, "fail", nil)
            }
        }
        
    }
}
