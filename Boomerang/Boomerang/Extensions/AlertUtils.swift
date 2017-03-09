//
//  AlertUtils.swift
//  Boomerang
//
//  Created by Felipe perius on 07/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class AlertUtils {
    class func showAlertErrorWithMessage(title: String, message : String, viewController : UIViewController?){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(actOk)
        
        if let view = viewController{
            view.present(alertController, animated: true, completion: nil)
        }else{
            let window = UIApplication.shared.keyWindow?.rootViewController
            window?.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func showAlertError(title: String, viewController : UIViewController?){
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let actOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(actOk)
        
        if let view = viewController{
            view.present(alertController, animated: true, completion: nil)
        }else{
            let window = UIApplication.shared.keyWindow?.rootViewController
            window?.present(alertController, animated: true, completion: nil)
        }
    }
    

    
    class func showAlertSuccess(title : String, message: String, viewController: UIViewController?){
        
        let alertController = UIAlertController(title: "\(title)", message: message, preferredStyle: .alert)
        
        let actOk = UIAlertAction(title: "OK", style: .default) {
            UIAlertAction in
            viewController?.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(actOk)
        
        if let view = viewController{
            view.present(alertController, animated: true, completion: nil)
        }
    }

}
