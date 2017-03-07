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
    
    
    func queryEqualToValue(className: String, key: String, value: Any, completionHandler: @escaping (_ success: Bool, _ msg: String, _ objects: [PFObject]?) -> Void) {
    
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
    
    func queryWithPredicate(className: String, predicate: NSPredicate, completionHandler: @escaping (_ success: Bool, _ msg: String, _ objects: [PFObject]?) -> Void) {
        
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
    
    func getDataBy(key: String, completionHandler: @escaping (_ success: Bool, _ msg: String, _ data: Data?) -> Void) {
        
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
    
    func getMultipleDataBy(keys: [String], completionHandler: @escaping (_ success: Bool, _ msg: String, _ data: [Data]?) -> Void) {
        
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
    
    func fetchObjectBy(key: String, completionHandler: @escaping (_ success: Bool, _ msg: String, _ data: PFObject?) -> Void) {
        
        let object = self.object(forKey: key) as? PFObject
        
        object?.fetchIfNeededInBackground(block: { (object, error) in
            
            if error == nil {
                completionHandler(true, "Success", object)
            } else {
                completionHandler(false, error.debugDescription, nil)
            }
        })
        
    }
    
    func fetchMultipleObjectsBy(keys: [String], completionHandler: @escaping (_ success: Bool, _ msg: String, _ objects: [PFObject]?) -> Void) {
        
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
