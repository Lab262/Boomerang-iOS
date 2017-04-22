//
//  EvaluationRequest.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 20/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class EvaluationRequest: NSObject {
    
    static func createEvaluation(evaluation: Evaluation, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        
        let newEvaluation = PFObject(className: "Evaluation")
        newEvaluation["scheme"] = ["__type": "Pointer", "className": "Scheme", "objectId": evaluation.scheme!.objectId]
        newEvaluation["comment"] = evaluation.comment!
        newEvaluation["amountStars"] = evaluation.amountStars!
        
        newEvaluation.saveInBackground { (success, error) in
            if error == nil {
                completionHandler(success, "success")
            } else {
                completionHandler(success, error!.localizedDescription)
            }
        }
    }

}
