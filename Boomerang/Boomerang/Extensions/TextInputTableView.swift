//
//  TextInputTableView.swift
//  OhMyBoxSellersIos
//
//  Created by Thiago-Bernardes on 24/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class TextInputTableView: UITableView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.endEditing(true)
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        
        let showKeyboardBlock = { (notification: Notification) in
            
            if let  obj = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] {
                var keyboardFrame = CGRect.null
                
                if (obj as AnyObject).responds(to: #selector(NSValue.getValue(_:))) {
                    (obj as AnyObject).getValue(&keyboardFrame)
                    
                    UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions(), animations: { 
                        self.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.size.height, 0.0)
                        self.scrollIndicatorInsets = self.contentInset
                        self.scrollToRow(at: IndexPath.init(row: 3, section: 0) , at: .bottom, animated: true)
                    }, completion: { (success) in
                        if success {
                            
//                            self.scrollToRow(at: IndexPath.init(row: 3, section: 0) , at: .bottom, animated: true)
                            
                        }
                    })
                    
                }
            }
            
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil) { (notification) in
            
            showKeyboardBlock(notification)
        }
        
        let hideKeyboardBlock = {
            
            UIView.animate(
                withDuration: 0.25,
                delay: 0.0,
                options: UIViewAnimationOptions(),
                animations: {
                    () -> Void in
                    self.contentInset = UIEdgeInsetsMake(156, 0, 0, 0)
            },
                completion: nil)
            
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil) { (notification) in
            
            hideKeyboardBlock()
        }
        
    }

}
