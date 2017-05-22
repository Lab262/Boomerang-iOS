//
//  ParseRequest.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 06/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse
import Foundation


enum QueryType {
    case common
    case and
    case or
}

enum WhereType {
    case containedIn
    case equal
    case greaterThan
}

class ParseRequest: NSObject {
    
    
//    static func delegateMultipleObjectsInClassesFor(queryMultipleParams: Dictionary<String, Dictionary<String, AnyObject>>, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
//        
//        let classes = queryMultipleParams.keys
//        
//        var query = PFQuery(className: "User")
//        
//        
//        for className in classes {
//            
//        }
//        
////        PFQuery *innerQuery = [PFQuery queryWithClassName:@"User"];
////        [innerQuery whereKey:@"userType" equalTo:@"X"];  // fix with your real user type
////        PFQuery *query = [PFQuery queryWithClassName:@"Post"];
////        [query whereKey:@"user" matchesQuery:innerQuery];
////        [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
////            // posts are posts where post.user.userType == X
////            }];
//        
//    }
    
    static func deleteObjectFor(className: String, queryParams: [String: Any], completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        let query = PFQuery(className: className)
        
        for queryParam in queryParams {
            query.whereKey(queryParam.key, equalTo: queryParam.value)
        }
    
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                PFObject.deleteAll(inBackground: objects, block: { (success, error) in
                    
                    if error == nil {
                        completionHandler(true, "success")
                    } else {
                        completionHandler(false, error!.localizedDescription)
                    }
                    
                })
            } else {
                completionHandler(false, error!.localizedDescription)
            }
        }
    }
    
    static func updateForIsDeletedObjectBy(className: String, queryParams: [String: Any], completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        let query = PFQuery(className: className)
        
        for queryParam in queryParams {
            query.whereKey(queryParam.key, equalTo: queryParam.value)
        }
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                objects?.forEach {
                    $0["isDeleted"] = true
                }
                PFObject.saveAll(inBackground: objects, block: { (success, error) in
                    if error == nil {
                        completionHandler(true, "success")
                    } else {
                        completionHandler(false, error!.localizedDescription)
                    }
                })
            } else {
                completionHandler(false, error!.localizedDescription)
            }
        }
    }
    
    
    static func queryCountEqualToValue(className: String, key: String, value: Any, completionHandler: @escaping (_ success: Bool, _ msg: String, _ count: Int?) -> Void) {
        
        let query = PFQuery(className: className)
        query.whereKey(key, equalTo: value)
        
        query.countObjectsInBackground { (count, error) in
            if error == nil {
                completionHandler(true, "Success", Int(count))
            } else {
                completionHandler(false, error.debugDescription, nil)
            }
        }
    }
    
    static func queryCountContainedIn(className: String, key: String, value: [Any], completionHandler: @escaping (_ success: Bool, _ msg: String, _ count: Int?) -> Void) {
        
        let query = PFQuery(className: className)
        query.whereKey(key, containedIn: value)
        
        query.countObjectsInBackground { (count, error) in
            if error == nil {
                completionHandler(true, "Success", Int(count))
            } else {
                completionHandler(false, error.debugDescription, nil)
            }
        }
    }
    
    static func queryGetAllObjects(className: String, notContainedObjects: [String: [Any]]? = nil, pagination: Int = 100, includes: [String]? = nil, completionHandler: @escaping (_ success: Bool, _ msg: String, _ objects :[PFObject]?) -> ()) {
        
        let query = PFQuery(className: className)
        
        query.limit = pagination
        
        if let allNotContainedObjects = notContainedObjects {
            allNotContainedObjects.forEach {
                query.whereKey($0.key, notContainedIn: $0.value)
            }
        }
        
        if let allIncludes = includes {
            allIncludes.forEach {
                query.includeKey($0)
            }
        }
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                completionHandler(true, "success", objects)
            } else {
                completionHandler(false, error!.localizedDescription, nil)
            }
        }
    }
    
    static func queryEqualToValueNotContainedObjects2(className: String, queryParams: [String: Any], includes: [String]?, selectKeys: [String]? = nil, pagination: Int? = 100, completionHandler: @escaping (_ success: Bool, _ msg: String, _ objects: [PFObject]?) -> Void) {
        
        //        for key in notContainedObjects.keys {
        //              query.whereKey(key, notContainedIn: notContainedObjects[key]!)
        //        }
        //
        
            let query = PFQuery(className: className)
            query.limit = pagination!
            query.skip = 0
            query.order(byDescending: "createdAt")
            // query.order(byAscending: "createdAt")
            for queryParam in queryParams {
                query.whereKey(queryParam.key, equalTo: queryParam.value)
            }
            if let allIncludes = includes {
                for include in allIncludes {
                    query.includeKey(include)
                }
            }
            query.findObjectsInBackground { (objects, error) in
                
                if error == nil {
                    completionHandler(true, "Success", objects)
                } else {
                    completionHandler(false, error.debugDescription, nil)
                }
            }
        }
    
    
    // QUERY 2
    
    static func queryEqualToValue2(className: String, queryParams: [String: Any], includes: [String]?, selectKeys: [String]? = nil, pagination: Int? = 100, skip: Int? = 0, completionHandler: @escaping (_ success: Bool, _ msg: String, _ objects: [PFObject]?) -> Void) {
        
            let query = PFQuery(className: className)
            query.limit = pagination!
            query.order(byDescending: "createdAt")
            
            for queryParam in queryParams {
                query.whereKey(queryParam.key, equalTo: queryParam.value)
            }
            if let keys = selectKeys {
                query.selectKeys(keys)
            }
            
            if let allIncludes = includes {
                for include in allIncludes {
                    query.includeKey(include)
                }
            }
            query.findObjectsInBackground { (objects, error) in
                if error == nil {
                    completionHandler(true, "Success", objects)
                } else {
                    completionHandler(false, error.debugDescription, nil)
                }
            }
        }

    
    static func findMultipleObjectsAt(querys: [PFQuery<PFObject>], indexQuery: Int,  allObjects: [PFObject], completionHandler: @escaping (_ success: Bool, _ msg: String, _ objects: [PFObject]) -> ()) {
        var localObjects = allObjects
        querys[indexQuery].findObjectsInBackground { (objects, error) in
            if error == nil {
                objects?.forEach {
                    localObjects.append($0)
                }
                var index = indexQuery
                index += index + 1
                if index > querys.count {
                    completionHandler(true, "success", objects!)
                } else {
                    findMultipleObjectsAt(querys: querys, indexQuery: index, allObjects: localObjects, completionHandler: { (success, msg, objects) in
                        completionHandler(success, msg, objects)
                    })
                }
            } else {
                completionHandler(false, error!.localizedDescription, localObjects)
            }
        }
    }
    
    static func setupQuery(className: String, key: String, values: [Any], cachePolicy: PFCachePolicy, pagination: Int, notContainedObjects: [String: [Any]]?, whereType: WhereType, includes: [String]?, order: String = "createdAt") -> PFQuery<PFObject> {
        
        let query = PFQuery(className: className)
        query.cachePolicy = cachePolicy
        
        if whereType == .equal {
           query.whereKey(key, equalTo: values[0])
        } else if whereType == .containedIn {
            query.whereKey(key, containedIn: values)
        }
        
        query.limit = pagination
        query.order(byDescending: order)

        if let allIncludes = includes {
            allIncludes.forEach {
                query.includeKey($0)
            }
        }
        
        if let allNotContainedObjects = notContainedObjects {
            allNotContainedObjects.forEach {
                query.whereKey($0.key, notContainedIn: $0.value)
            }
        }

        return query
    }
    
    static func setupQueryAnd(className: String, params: [String: [Any]], cachePolicy: PFCachePolicy, pagination: Int, notContainedObjects: [String: [Any]]?, whereTypes: [WhereType], includes: [String]?, order: String = "createdAt") -> PFQuery<PFObject> {
        
        let query = PFQuery(className: className)
        query.cachePolicy = cachePolicy
        
        if whereTypes[0] == .equal && whereTypes[1] == .greaterThan {
            for (i, param) in params.enumerated() {
                if i == 0 {
                    query.whereKey(param.key, greaterThan: param.value[0])
                } else {
                    query.whereKey(param.key, equalTo: param.value[0])
                }
            }
        } else if whereTypes[0] == .greaterThan && whereTypes[1] == .equal {
            for (i, param) in params.enumerated() {
                if i == 0 {
                    query.whereKey(param.key, greaterThan: param.value)
                } else {
                    query.whereKey(param.key, equalTo: param.value)
                }
            }
        }
        
        query.limit = pagination
        query.order(byDescending: order)
        
        if let allIncludes = includes {
            allIncludes.forEach {
                query.includeKey($0)
            }
        }
        
        if let allNotContainedObjects = notContainedObjects {
            allNotContainedObjects.forEach {
                query.whereKey($0.key, notContainedIn: $0.value)
            }
        }
        
        return query
    }
    
    static func queryToUpdateToDeletedWithParams(className: String, params: [String: Any], completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        let query = PFQuery(className: className)
        
        for param in params {
            query.whereKey(param.key, equalTo: param.value)
        }
        
        query.findObjectsInBackground { (objects, error) in
            if let _ = error {
                completionHandler(false, error!.localizedDescription)
            } else {
                for object in objects! {
                    object["isDeleted"] = true
                    object.saveInBackground(block: { (success, error) in
                        if let _ = error {
                            completionHandler(success, error!.localizedDescription)
                        } else {
                            completionHandler(success, "Save Success")
                        }
                    })
                }
            }
        }
    }
    
    static func queryToUpdateToDeleted(className: String? = nil, object: PFObject, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        let query = PFQuery(className: className ?? object.parseClassName)
    
        query.getObjectInBackground(withId: object.objectId!) { (object, error) in
            
            if let _ = error {
                completionHandler(false, error!.localizedDescription)
            } else {
                if let obj = object {
                    obj["isDeleted"] = true
                    obj.saveInBackground(block: { (success, error) in
                        if let _ = error {
                            completionHandler(success, error!.localizedDescription)
                        } else {
                            completionHandler(success, "Save success")
                        }
                    })
                } else {
                    completionHandler(false, "object is nil")
                }
            }
        }
    }
    
    
    static func queryEqualToValueNotContainedObjects(className: String, queryType: QueryType, whereTypes: [WhereType], params: [String: [Any]], cachePolicy: PFCachePolicy, notContainedObjects: [String: [Any]]?, includes: [String]?, pagination: Int, order: String = "createdAt", completionHandler: @escaping (_ success: Bool, _ msg: String, _ objects: [PFObject]?) -> ()) {
        
        switch queryType {
        
        case .common:
            var query = PFQuery()
            for param in params {
                query = setupQuery(className: className, key: param.key, values: param.value, cachePolicy: cachePolicy, pagination: pagination, notContainedObjects: notContainedObjects, whereType: whereTypes[0], includes: includes)
            }
            
            query.findObjectsInBackground { (objects, error) in
                if error == nil {
                    completionHandler(true, "Success", objects)
                } else {
                    completionHandler(false, error.debugDescription, nil)
                }
            }
            
        case .or:
            var allQueries = [PFQuery]()
            for param in params {
                let query = setupQuery(className: className, key: param.key, values: param.value, cachePolicy: cachePolicy, pagination: pagination, notContainedObjects: notContainedObjects!, whereType: whereTypes[0], includes: includes!)
                allQueries.append(query)
            }
            findMultipleObjectsAt(querys: allQueries, indexQuery: 0, allObjects: [PFObject](), completionHandler: { (success, msg, objects) in
                    completionHandler(success, msg, objects)
                })
            
        case .and:
            var query = PFQuery()
            
            query = setupQueryAnd(className: className, params: params, cachePolicy: cachePolicy, pagination: pagination, notContainedObjects: notContainedObjects, whereTypes: whereTypes, includes: includes)
            
            query.findObjectsInBackground { (objects, error) in
                if error == nil {
                    completionHandler(true, "Success", objects)
                } else {
                    completionHandler(false, error.debugDescription, nil)
                }
            }
        }
    }
    
 
    
    static func queryEqualToValueNotContained(className: String, queryParams: [String: Any], notContainedIds: [String], includes: [String]?, selectKeys: [String]? = nil, pagination: Int? = 100, completionHandler: @escaping (_ success: Bool, _ msg: String, _ objects: [PFObject]?) -> Void) {
        
        let query = PFQuery(className: className)
        query.whereKey("objectId", notContainedIn: notContainedIds)
        query.limit = pagination!
        query.order(byDescending: "createdAt")
        
        for queryParam in queryParams {
            query.whereKey(queryParam.key, equalTo: queryParam.value)
        }
        if let keys = selectKeys {
            query.selectKeys(keys)
        }
        
        if let allIncludes = includes {
            for include in allIncludes {
                query.includeKey(include)
            }
        }
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                completionHandler(true, "Success", objects)
            } else {
                completionHandler(false, error.debugDescription, nil)
            }
        }
    }

    static func queryEqualToValue(className: String, queryParams: [String: Any], includes: [String]?, selectKeys: [String]? = nil, pagination: Int? = 100, skip: Int? = 0, completionHandler: @escaping (_ success: Bool, _ msg: String, _ objects: [PFObject]?) -> Void) {
        
        if queryParams.count > 1 {
            var allQueries = [PFQuery]()
            for queryParam in queryParams {
                let query = PFQuery(className: className)
                query.whereKey(queryParam.key, equalTo: queryParam.value)
                if let keys = selectKeys {
                    query.selectKeys(keys)
                }
                if let allIncludes = includes {
                    for include in allIncludes {
                        query.includeKey(include)
                    }
                }
                allQueries.append(query)
            }
            var allObjects = [PFObject]()
            let firstQuery = allQueries.first
            
            firstQuery?.findObjectsInBackground { (objects, error) in
            
                if error == nil {
                    for object in objects! {
                        allObjects.append(object)
                    }
                    let secondQuery = allQueries.last
                    secondQuery?.findObjectsInBackground(block: { (objects, error) in
                        if error == nil {
                            for object in objects! {
                                allObjects.append(object)
                            }
                            completionHandler(true, "Success", allObjects)
                        } else {
                            completionHandler(false, error.debugDescription, nil)
                        }
                    })
                   // completionHandler(true, "Success", objects)
                } else {
                    completionHandler(false, error.debugDescription, nil)
                }
            }
        } else {
            
            let query = PFQuery(className: className)
            query.skip = skip!
            query.limit = pagination!
            query.order(byDescending: "createdAt")
           
            for queryParam in queryParams {
                query.whereKey(queryParam.key, equalTo: queryParam.value)
            }
            if let keys = selectKeys {
                query.selectKeys(keys)
            }
            
            if let allIncludes = includes {
                for include in allIncludes {
                    query.includeKey(include)
                }
            }
            query.findObjectsInBackground { (objects, error) in
                if error == nil {
                    completionHandler(true, "Success", objects)
                } else {
                    completionHandler(false, error.debugDescription, nil)
                }
            }
        }
    }

    static func queryContainedIn(className: String, queryType: QueryType, whereType: WhereType, includes: [String]?, cachePolicy: PFCachePolicy, params: [String: [Any]], notContainedObjects: [String: [Any]], pagination: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, _ objects: [PFObject]?) -> Void) {
        
        switch queryType {
        case .common:
            
            var query = PFQuery()
            for param in params {
                query = setupQuery(className: className, key: param.key, values: param.value, cachePolicy: cachePolicy, pagination: pagination, notContainedObjects: notContainedObjects, whereType: whereType, includes: includes)
            }
            
            query.findObjectsInBackground { (objects, error) in
                if error == nil {
                    completionHandler(true, "Success", objects)
                } else {
                    completionHandler(false, error.debugDescription, nil)
                }
            }
        default:
            break
        }
//        
//        let query = PFQuery(className: className)
//        query.whereKey(key, containedIn: value)
//        query.limit = pagination
//        
//        query.findObjectsInBackground { (objects, error) in
//            
//            if error == nil {
//                completionHandler(true, "Success", objects)
//                
//            } else {
//                completionHandler(false, error.debugDescription, nil)
//            }
//        }
    }
    
    static func queryContainedInWithInclude(className: String, key: String, value: [Any], include: String, pagination: Int? = 100, skip: Int? = 0, completionHandler: @escaping (_ success: Bool, _ msg: String, _ objects: [PFObject]?) -> Void) {
        
        let query = PFQuery(className: className)
        query.whereKey(key, containedIn: value)
        query.includeKey(include)
        query.limit = pagination!
        query.skip = skip!
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                completionHandler(true, "Success", objects)
                
            } else {
                completionHandler(false, error.debugDescription, nil)
            }
        }
    }
    
    static func queryWithPredicate(className: String, predicate: NSPredicate, completionHandler: @escaping (_ success: Bool, _ msg: String, _ objects: [PFObject]?) -> Void) {
        
        let query = PFQuery(className: className, predicate: predicate)
        
        query.findObjectsInBackground { (objects, error) in
            
            if error == nil {
                completionHandler(true, "Success", objects)
            } else {
                completionHandler(false, error.debugDescription, nil)
            }
        }
    }

}

extension PFObject {
    
    func getRelationCountInBackgroundBy(key: String, completionHandler: @escaping (_ success: Bool, _ msg: String, _ count: Int?) -> Void) {
     
        let relation = self.relation(forKey: key)
        let query = relation.query()

        query.countObjectsInBackground { (count, error) in
            if error == nil {
                completionHandler(true, "Success", Int(count))
            } else {
                completionHandler(false, error.debugDescription, nil)
            }
        }
        
    }
    
    func getRelationsInBackgroundBy(key: String, keyColunm: String? = "", isNotContained: Bool? = false, pagination: Int? = 100, skip: Int? = 0, notContainedKeys: [Any]? = [Any](), completionHandler: @escaping (_ success: Bool, _ msg: String, _ objects: [PFObject]?) -> Void) {
        
        let relation = self.relation(forKey: key)
        let query = relation.query()
        query.limit = pagination!
        query.skip = skip!
        query.order(byAscending: "createdAt")
        
//        if isNotContained! {
//            query.whereKey(keyColunm!, notContainedIn: notContainedKeys!)
//        }
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                completionHandler(true, "Success", objects)
            }
        }
    }
    
    func createRelationInBackground(key: String, object: PFObject, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        let relation = self.relation(forKey: key)
        
        relation.add(object)
        
        self.saveInBackground { (success, error) in
            completionHandler(success, error.debugDescription)
        }
        
//        self.saveObjectInBackground { (success, msg) in
//            completionHandler(success, msg)
//        }
    }
    
    func getRelationsInBackgroundWithDataBy(key: String, keyFile: String, isNotContained: Bool = false, notContainedKeys: [Any] = [Any](), completionHandler: @escaping (_ success: Bool, _ msg: String, _ relations: [PFObject]?, _ data: Data?) -> Void) {
        
        getRelationsInBackgroundBy(key: key, keyColunm: keyFile, isNotContained: isNotContained, notContainedKeys: notContainedKeys) { (success, msg, relations) in
            if success {
                for relation in relations! {
                    relation.getDataInBackgroundBy(key: keyFile, completionHandler: { (success, msg, data) in
                        
                        if success {
                            completionHandler(true, "Success", relations, data)
                        } else {
                            completionHandler(false, msg, relations, nil)
                        }
                    })
                }
            } else {
                completionHandler(false, msg, nil, nil)
            }
        }
    }
    
    func getRelationsBy(key: String) -> [PFObject]? {
        let relation = self.relation(forKey: key)
        let query = relation.query()
        
        do {
            return try query.findObjects()
        } catch {
            return nil
        }
    }
    
    func getRelationWithDataBy(key: String, keyFile: String) -> [Data]? {
        var datas = [Data]()
        
        if let relations = getRelationsBy(key: key) {
            for relation in relations {
                if let data = relation.getDataBy(key: keyFile) {
                    datas.append(data)
                }
            }
            return datas
        } else {
            return nil
        }
    }
    
    func getDataBy(key: String) -> Data? {
        let file = self.object(forKey: key) as? PFFile
        
        do {
            return try file?.getData()
        } catch {
            return nil
        }
    }
    
    func getDataInBackgroundBy(key: String, completionHandler: @escaping (_ success: Bool, _ msg: String, _ data: Data?) -> Void) {
        
        let file = self.object(forKey: key) as? PFFile
        
        file?.getDataInBackground(block: { (data, error) in
            if error == nil {
                if let data = data {
                    completionHandler(true, "Success", data)
                } else {
                    completionHandler(false, "data is nil", nil)
                }
            } else {
                completionHandler(false, error.debugDescription, nil)
            }
        })
    }
    
    func getMultipleDataInBackgroundBy(keys: [String], completionHandler: @escaping (_ success: Bool, _ msg: String, _ data: [Data]?) -> Void) {
        
        var tasks = [BFTask<AnyObject>]()
        
        for (_, key) in keys.enumerated() {
            let file = self.object(forKey: key) as? PFFile
            let task = file!.getDataInBackground()
            tasks.append(task as! BFTask<AnyObject>)
        }
        
        BFTask<AnyObject>(forCompletionOfAllTasksWithResults: tasks as [BFTask<AnyObject>]?).continue({ task in
            
            if task.error == nil {
                
                completionHandler(true, "success", task.result as? [Data])
            } else {
    
                completionHandler(false, task.error.debugDescription, nil)
            }
            
            return nil
            
        })
    }
    
    
    func saveObjectInBackground(completionHandler: @escaping (_ success: Bool, _ msg: String) -> Void) {
        
        let object = PFObject(className: self.parseClassName)
        let keys = self.allKeys
        let values = keys.map { self.value(forKey: $0) }
        
        for case let (i, value?) in values.enumerated() {
            object[keys[i]] = value
        }
        
        object.saveInBackground { (success, error) in
            if success {
                completionHandler(true, "SUCCESS")
            } else {
                completionHandler(false, error.debugDescription)
            }
        }
    }
    
    func fetchObjectInBackgroundBy(key: String, completionHandler: @escaping (_ success: Bool, _ msg: String, _ data: PFObject?) -> Void) {
        
        let object = self.object(forKey: key) as? PFObject
        
        object?.fetchIfNeededInBackground(block: { (object, error) in
            
            if error == nil {
                completionHandler(true, "Success", object)
            } else {
                completionHandler(false, error.debugDescription, nil)
            }
        })
    }
    
    func fetchObjectBy(key: String) -> PFObject? {
        
        let object = self.object(forKey: key) as? PFObject
        
        do {
            return try object?.fetchIfNeeded()
        } catch {
            return nil
        }
    }
    
    func fetchMultipleObjectsInBackgroundBy(keys: [String], completionHandler: @escaping (_ success: Bool, _ msg: String, _ objects: [PFObject]?) -> Void) {
        
        
        var tasks = [BFTask<AnyObject>]()
        
        for (_, key) in keys.enumerated() {
            let object = self.object(forKey: key) as? PFObject
            let task = object?.fetchIfNeededInBackground()
            tasks.append(task as! BFTask<AnyObject>)
        }
        
        BFTask<AnyObject>(forCompletionOfAllTasksWithResults: tasks as [BFTask<AnyObject>]?).continue({ task in
            
            if task.error == nil {
                
                completionHandler(true, "success", task.result as? [PFObject])
            } else {
                
                completionHandler(false, task.error.debugDescription, nil)
            }
            
            return nil
            
        })
    }
}

extension UIImageView {
    
    func getUserImage(profile: Profile, completionHandler: @escaping (_ success: Bool, _ msg: String) -> Void) {
        guard let image = profile.profileImage else {
            self.loadAnimation()
            profile.getDataInBackgroundBy(key: #keyPath(User.photo), completionHandler: { (success, msg, data) in
                if success {
                    self.image = UIImage(data: data!)
                    completionHandler(true, "Success")
                } else {
                    completionHandler(false, msg)
                }
                self.unload()
            })
            return
        }
        self.image = image
        completionHandler(true, "Success")
    }
    
    func getUserImageFrom(file: PFFile, completionHandler: @escaping (_ success: Bool, _ msg: String) -> Void) {
        loadAnimation()
        file.getDataInBackground { (data, error) in
            if error == nil {
                self.image = UIImage(data: data!)
                completionHandler(true, "Success")
            } else {
                completionHandler(false, error!.localizedDescription)
            }
            self.unload()
        }
    }
}
