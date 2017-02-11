//
//  ViewUtil.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 10/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class ViewUtil: NSObject {
    

    
    class func viewControllerFromStoryboardWithIdentifier(_ name: String, identifier: String = "")->UIViewController?{
        
        if let storyboard : UIStoryboard = UIStoryboard(name: name as String, bundle: nil){
            if identifier != "" {
                return storyboard.instantiateViewController(withIdentifier: identifier as String)
            }else{
                return storyboard.instantiateInitialViewController()!
            }
        }else{
            return nil
        }
        
    }
    
  
    static func alertControllerWithTitle (_title: String, _withMessage _message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        return alert
    }
    

    static func imageFromColor (_ color: UIColor, forSize size: CGSize, withCornerRadius radius: CGFloat) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        UIGraphicsBeginImageContext(size)
        UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
        image.draw(in: rect)
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
        
    }



}

extension UIView {
    
    
    func loadAnimation(_ duration: TimeInterval = 0.2) {
        
        if let _ = viewWithTag(10) {
            //View is already locked
        }
        else {
            let lockView = UIView(frame: bounds)
            lockView.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
            lockView.tag = 10
            lockView.alpha = 0.0
            let activity = UIActivityIndicatorView(activityIndicatorStyle: .white)
            activity.hidesWhenStopped = true
            
            activity.center = lockView.center
            
            activity.translatesAutoresizingMaskIntoConstraints = false
            
            lockView.addSubview(activity)
            activity.startAnimating()
            
            self.addSubview(lockView)
            
            let xCenterConstraint = NSLayoutConstraint(item: activity, attribute: .centerX, relatedBy: .equal, toItem: lockView, attribute: .centerX, multiplier: 1, constant: 0)
            
            let yCenterConstraint = NSLayoutConstraint(item: activity, attribute: .centerY, relatedBy: .equal, toItem: lockView, attribute: .centerY, multiplier: 1, constant: 0)
            
            
            NSLayoutConstraint.activate([xCenterConstraint, yCenterConstraint])
            
            UIView.animate(withDuration: duration, animations: {
                lockView.alpha = 1.0
            })
        }
    }
    
    func unload(_ duration: TimeInterval = 0.2) {
        if let lockView = self.viewWithTag(10) {
            
            UIView.animate(withDuration: duration, animations: {
                lockView.alpha = 0.0
            }, completion: { finished in
                lockView.removeFromSuperview()
            })
        }
    }
}
