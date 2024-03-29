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
    
    static func finalize(for scheme: Scheme, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        let allStatus = ApplicationState.sharedInstance.schemeStatus
        var queryParams = [String: Any]()
        queryParams[ObjectKeys.objectId] = scheme.objectId
        var colunmsUpdated = [String: Any]()
        
        for status in allStatus where status.objectId == StatusSchemeId.finished {
            colunmsUpdated[SchemeKeys.status] = status
        }
        
        ParseRequest.updateObject(className: scheme.parseClassName, queryParams: queryParams, colunmsUpdated: colunmsUpdated) { (success, msg) in
            completionHandler(success, msg)
        }
    }
    
    static func updateScheme(scheme: Scheme, statusScheme: StatusScheme, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        let allStatus = ApplicationState.sharedInstance.schemeStatus
        var queryParams = [String: Any]()
        queryParams[ObjectKeys.objectId] = scheme.objectId
        var colunmsUpdated = [String: Any]()
        
        for status in allStatus where status.status == statusScheme.rawValue {
            colunmsUpdated[SchemeKeys.status] = status
        }
        
        ParseRequest.updateObject(className: scheme.parseClassName, queryParams: queryParams, colunmsUpdated: colunmsUpdated) { (success, msg) in
            completionHandler(success, msg)
        }
    }
    
    static func getSchemeFor(owner: Profile, requester: Profile, post: Post, completionHandler: @escaping (_ success: Bool, _ msg: String, _ scheme: Scheme?) -> ()) {
        
        let query = PFQuery(className: Scheme.parseClassName())
        query.whereKey(SchemeKeys.owner, equalTo: owner)
        query.whereKey(SchemeKeys.requester, equalTo: requester)
        query.whereKey(SchemeKeys.post, equalTo: post)
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                if objects!.count > 0 {
                    let scheme = objects![0] as? Scheme
                    completionHandler(true, "success", scheme!)
                } else {
                    completionHandler(false, "sem objects", nil)
                }
            } else {
                completionHandler(false, error.debugDescription, nil)
            }
        }
    }
    
    static func getSchemesForUser(owner: Profile, schemesDownloaded: [Scheme], notContainedStatus: [StatusScheme], pagination: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, _ schemes: [Scheme]?) -> ()) {
        
        var schemes = [Scheme]()
        var queryParams = [String : [Any]]()
        queryParams[SchemeKeys.owner] = [owner]
        queryParams[SchemeKeys.requester] = [owner]
        
        var notContainedObjects = [String: [Any]]()
        var notContainedObjectIds = [String]()
    
        schemesDownloaded.forEach{
            notContainedObjectIds.append($0.objectId!)
        }
        
        notContainedObjects[ObjectKeys.objectId] = notContainedObjectIds
        notContainedObjects[SchemeKeys.status] = getNotContainedStatus(statusScheme: notContainedStatus)

        ParseRequest.queryEqualToValueNotContainedObjects(className: SchemeKeys.className, queryType: .or, whereTypes: [.equal], params: queryParams, cachePolicy: .networkElseCache, notContainedObjects: notContainedObjects, includes: [SchemeKeys.requester, SchemeKeys.owner,SchemeKeys.post], pagination: pagination) { (success, msg, objects) in
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
    
    
    static func getRequesterSchemesForUser(requester: Profile, schemesDownloaded: [Scheme], notContainedStatus: [StatusScheme], pagination: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, _ schemes: [Scheme]?) -> ()) {
        
        var schemes = [Scheme]()
        var queryParams = [String : [Any]]()
        queryParams[SchemeKeys.requester] = [requester]
        
        var notContainedObjects = [String: [Any]]()
        var notContainedObjectIds = [String]()
        
        schemesDownloaded.forEach{
            notContainedObjectIds.append($0.objectId!)
        }
        
        notContainedObjects[ObjectKeys.objectId] = notContainedObjectIds
        notContainedObjects[SchemeKeys.status] = getNotContainedStatus(statusScheme: notContainedStatus)
        
        ParseRequest.queryEqualToValueNotContainedObjects(className: SchemeKeys.className, queryType: .common, whereTypes: [.equal], params: queryParams, cachePolicy: .networkElseCache, notContainedObjects: notContainedObjects, includes: [SchemeKeys.owner, SchemeKeys.post, SchemeKeys.requester], pagination: pagination) { (success, msg, objects) in
            
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
    
    static func getOwnerSchemesForUser(owner: Profile, schemesDownloaded: [Scheme], notContainedStatus: [StatusScheme], pagination: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, _ schemes: [Scheme]?) -> ()) {
        
        var schemes = [Scheme]()
        var queryParams = [String : [Any]]()
        queryParams[SchemeKeys.owner] = [owner]
        
        var notContainedObjects = [String: [Any]]()
        var notContainedObjectIds = [String]()
        
        schemesDownloaded.forEach{
            notContainedObjectIds.append($0.objectId!)
        }
        
        notContainedObjects[ObjectKeys.objectId] = notContainedObjectIds
        notContainedObjects[SchemeKeys.status] = getNotContainedStatus(statusScheme: notContainedStatus)
        
        ParseRequest.queryEqualToValueNotContainedObjects(className: SchemeKeys.className, queryType: .common, whereTypes: [.equal], params: queryParams, cachePolicy: .networkElseCache, notContainedObjects: notContainedObjects, includes: [SchemeKeys.owner, SchemeKeys.post, SchemeKeys.requester], pagination: pagination) { (success, msg, objects) in
            
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
        ParseRequest.queryGetAllObjects(className: SchemeStatus.parseClassName()) { (success, msg, objects) in
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
