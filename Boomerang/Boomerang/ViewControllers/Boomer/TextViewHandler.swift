//
//  TextViewHandler.swift
//  Boomerang
//
//  Created by Felipe perius on 06/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

typealias textViewEnd = (String!) -> Void

class TextViewHandler: NSObject, UITextViewDelegate {
    
    var textView: UITextView?
    var completation: textFieldEnd!
    
    
    init(textView: UITextView) {
        
        super.init()
        
        self.textView = textView
        
        self.textView?.delegate = self
        
        
        self.textView?.isEditable = true
        
        NotificationCenter.default.addObserver(self, selector: (#selector(TextViewHandler.didEnd(_:))), name: NSNotification.Name(rawValue: "DISMISS_KEYBOARD"), object: nil)
        
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        print ("entrou end")
        textView.resignFirstResponder()
        self.completation(textView.text)
        return true
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        print ("entrou")
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    @objc func didEnd (_ notification: Notification) {
        self.textView?.resignFirstResponder()
    }
    
    
    func textViewDidMiss (_ textView: UITextView) {
        
        self.textViewDidEndEditing(textView)
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print ("text view did enditing")
        textView.resignFirstResponder()
        self.completation(textView.text)
    }
    
    func textFieldShouldReturn(_ textView: UITextView) -> Bool {
        
        textView.resignFirstResponder()
        self.completation(textView.text)
        
        return true
    }
    
}
