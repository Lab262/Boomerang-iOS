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
        
        BFTask<AnyObject>(forCompletionOfAllTasksWithResults: tasks as [BFTask<AnyObject>]?).continue({ task -> Any? in
            
            completionHandler(true, "success", task.result as? [Data])
            
        })

    }
}
