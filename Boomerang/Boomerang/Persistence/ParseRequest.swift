//
//  ParseRequest.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 06/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class ParseRequest: NSObject {
    
    static func queryEqualToValue(className: String, key: String, value: Any, completionHandler: @escaping (_ success: Bool, _ msg: String, _ objects: [PFObject]?) -> Void) {
    
        let query = PFQuery(className: className)
        query.whereKey(key, equalTo: value)
        
        query.findObjectsInBackground { (objects, error) in
            
            if error == nil {
                completionHandler(true, "Success", objects)
            } else {
                completionHandler(false, error.debugDescription, nil)
            }
        }
    }
    
    
    static func queryContainedIn(className: String, key: String, value: [Any], completionHandler: @escaping (_ success: Bool, _ msg: String, _ objects: [PFObject]?) -> Void) {
        
        let query = PFQuery(className: className)
        query.whereKey(key, containedIn: value)
        
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
    
    func getRelationInBackgroundBy(key: String, completionHandler: @escaping (_ success: Bool, _ msg: String, _ data: [PFObject]?) -> Void) {

        let relation = self.relation(forKey: key)
        let query = relation.query()
        
        query.findObjectsInBackground(block: { (objects, error) in
            if error == nil {
                completionHandler(true, "Success", objects)
            } else{
                completionHandler(false, error.debugDescription, nil)
            }
        })
    }
    
    
    func getRelationsInBackgroundBy(key: String, completionHandler: @escaping (_ success: Bool, _ msg: String, _ objects: [PFObject]?) -> Void) {
        
        let relation = self.relation(forKey: key)
        let query = relation.query()
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                completionHandler(true, "Success", objects)
            }
        }
    }
    
    func getRelationsInBackgroundWithDataBy(key: String, keyFile: String, completionHandler: @escaping (_ success: Bool, _ msg: String, _ relations: [PFObject]?, _ data: Data?) -> Void) {
        
        getRelationsInBackgroundBy(key: key) { (success, msg, relations) in
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
