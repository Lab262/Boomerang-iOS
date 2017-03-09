//
//  TextFieldHandler.swift
//  Boomerang
//
//  Created by Felipe perius on 06/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

typealias textFieldEnd = (String!) -> Void

class TextFieldHandler: NSObject, UITextFieldDelegate {
    
    var textField: UITextField!
    var completation: textFieldEnd!
    var dataObject: [String]?
    
    init(_textField: UITextField) {
        super.init()
        
        self.textField = _textField
        self.textField.delegate = self
        self.textField.addTarget(self, action: #selector(textFieldDidMiss(_:)), for: UIControlEvents.editingDidEnd)
        
        NotificationCenter.default.addObserver(self, selector: (#selector(didEnd(_:))), name: NSNotification.Name(rawValue: "DISMISS_KEYBOARD"), object: nil)
    }
    
    @objc func didEnd (_ notification: Notification) {
        self.textField.resignFirstResponder()
    }
    
    func textFieldDidMiss (_ textField: UITextField) {
        
        self.textFieldDidEndEditing(textField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        self.completation(textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.completation(textField.text)
        
        return true
    }
    
    
}

