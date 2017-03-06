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
    
//    static func getDataFrom(object: PFObject, key: String, completionHandler: @escaping (_ success: Bool, _ msg: String, _ data: Data?) -> Void) {
//        
//        let file = object.object(forKey: key) as? PFFile
//        
//        file?.getDataInBackground(block: { (data, error) in
//            if error == nil {
//                if let data = data {
//                    completionHandler(true, "Success", data)
//                } else {
//                    completionHandler(false, "data is nil", nil)
//                }
//            } else {
//                completionHandler(false, error.debugDescription, nil)
//            }
//        })
//    }
}

extension PFObject {
    
    func getDataFrom(key: String, completionHandler: @escaping (_ success: Bool, _ msg: String, _ data: Data?) -> Void) {
        
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
    
    func getMultipleDataFrom(keys: [String], completionHandler: @escaping (_ success: Bool, _ msg: String, _ data: [Data]?) -> Void) {
        
        
//        PFFile *file1 = object[@"image1"];
//        PFFile *file2 = object[@"image2"];
//        BFTask* task1 = [file1 getDataInBackground];
//        BFTask* task2 = [file2 getDataInBackground];
//        [BFTask taskForCompletionOfAllTasks:@[task1, task2]] continueWithBlock:^id(BFTask *task) {
//            if(!task.error){
//                UIImage* image1 = [UIImage imageWithData:task1.result];
//                UIImage* image2 = [UIImage imageWithData:task2.result];
//                // do your thing with the images
//            }
//            return nil;
//        }];
        
        var files = [PFFile]()
        var tasks = [BFTask<AnyObject>]()
        
        
        for (_, key) in keys.enumerated() {
            let file = self.object(forKey: key) as? PFFile
            files.append(file!)
        }
        
        for (_, file) in files.enumerated() {
            let task = file.getDataInBackground()
            tasks.append(task as! BFTask<AnyObject>)
        }
        
        BFTask<AnyObject>(forCompletionOfAllTasksWithResults: tasks as [BFTask<AnyObject>]?).continue({ task -> Any? in
            
         
            completionHandler(true, "success", task.result as? [Data])
            
        })

    }
    
        
        //        [BFTask taskForCompletionOfAllTasks:@[task1, task2]] continueWithBlock:^id(BFTask *task) {
        //            if(!task.error){
        //                UIImage* image1 = [UIImage imageWithData:task1.result];
        //                UIImage* image2 = [UIImage imageWithData:task2.result];
        //                // do your thing with the images
        //            }
        //            return nil;
        //        }];

        
        
        
//        file?.getDataInBackground(block: { (data, error) in
//            if error == nil {
//                if let data = data {
//                    completionHandler(true, "Success", data)
//                } else {
//                    completionHandler(false, "data is nil", nil)
//                }
//            } else {
//                completionHandler(false, error.debugDescription, nil)
//            }
//        })
//    }
}
