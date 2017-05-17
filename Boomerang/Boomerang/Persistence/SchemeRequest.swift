//
//  SchemeRequest.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 11/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class SchemeRequest: NSObject {
    
//    static func createScheme(requester: Profile, owner: Profile, chat: Chat, post: Post, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
//        
//        let scheme = PFObject(className: "Scheme")
//        scheme["post"] = ["__type": "Pointer", "className": "Post", "objectId": post.objectId]
//        scheme["requester"] = ["__type": "Pointer", "className": "_User", "objectId": requester.objectId]
//        scheme["owner"] = ["__type": "Pointer", "className": "_User", "objectId": owner.objectId]
//        scheme["chat"] = ["__type": "Pointer", "className": "Chat", "objectId": chat.objectId]
//        
//        scheme.saveInBackground { (success, error) in
//            if error == nil {
//                completionHandler(success, "success")
//            } else {
//                completionHandler(success, error!.localizedDescription)
//            }
//        }
//    }
    
    static func getNotContainedStatus(statusScheme: [StatusScheme]) -> [SchemeStatus] {
        
        let allStatus = ApplicationState.sharedInstance.schemeStatus
        var notContainedStatusObject = [SchemeStatus]()
        
        for statusObject in allStatus {
            for status in statusScheme where statusObject.status == status.rawValue{
                notContainedStatusObject.append(statusObject)
            }
        }
        
        return notContainedStatusObject
    }
    
    static func getSchemesForUser(owner: Profile, schemesDownloaded: [Scheme], notContainedStatus: [StatusScheme], pagination: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, _ schemes: [Scheme]?) -> ()) {
        
        var schemes = [Scheme]()
        var queryParams = [String : [Any]]()
        queryParams["owner"] = [owner]
        queryParams["requester"] = [owner]
        
        var notContainedObjects = [String: [Any]]()
        var notContainedObjectIds = [String]()
    
        schemesDownloaded.forEach{
            notContainedObjectIds.append($0.objectId!)
        }
        
        notContainedObjects["objectId"] = notContainedObjectIds
        notContainedObjects["status"] = getNotContainedStatus(statusScheme: notContainedStatus)

        ParseRequest.queryEqualToValueNotContainedObjects(className: "Scheme", queryType: .or, whereType: .equal, params: queryParams, notContainedObjects: notContainedObjects, includes: ["requester", "owner", "post"], pagination: pagination) { (success, msg, objects) in
            if success {
                for obj in objects! {
                    let scheme = Scheme(object: obj)
                    schemes.append(scheme)
                }
                completionHandler(success, msg, schemes)
            } else {
                completionHandler(success, msg, nil)
            }
        }
    }
    
    static func getAllStatus(completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        var schemeStatus = [SchemeStatus]()
        ParseRequest.queryGetAllObjects(className: "SchemeStatus") { (success, msg, objects) in
            if success {
                objects!.forEach {
                    let status = SchemeStatus(object: $0)
                    schemeStatus.append(status)
                }
                ApplicationState.sharedInstance.schemeStatus = schemeStatus
            }
            completionHandler(success, msg)
        }
    }
}
