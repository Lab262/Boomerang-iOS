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
  
  
    static func alertControllerWithTitle (title: String, withMessage message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
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
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    //func add
    
    func loadPlaceholderImage(_ placeHolderImage: UIImage, _ frame: CGRect){
        
        let imageView = UIImageView(image: placeHolderImage)
        imageView.tag = 2
        imageView.frame = frame
        
        self.addSubview(imageView)
    }
    
    func unloadPlaceholderImage(){
        
        if let imageView = viewWithTag(2) {
            imageView.removeFromSuperview()
        }
    }
    
    func loadAnimation(_ duration: TimeInterval = 0.2, _ backgroundColor: UIColor = UIColor(white: 0.0, alpha: 0.75), _ indicatorStyle: UIActivityIndicatorViewStyle = .white, _ alpha: CGFloat = 0.0) {
        
        if let _ = viewWithTag(10) {
            //View is already locked
        }
        else {
            let lockView = UIView(frame: bounds)
            lockView.backgroundColor = backgroundColor
            lockView.tag = 10
            lockView.alpha = alpha
            let activity = UIActivityIndicatorView(activityIndicatorStyle: indicatorStyle)
            
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
    
    func setX(x:CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.x = x
        self.frame = frame
    }
   
    func setY(y:CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.y = y
        self.frame = frame
    }
  
    func setWidth(width:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.width = width
        self.frame = frame
    }
    
    func setHeight(height:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.height = height
        self.frame = frame
    }
    
    static func heightScaleProportion() -> CGFloat {
        return UIScreen.main.bounds.height / 667.0
    }
    
    static func widthScaleProportion() -> CGFloat {
        return UIScreen.main.bounds.width / 375.0
    }
}
