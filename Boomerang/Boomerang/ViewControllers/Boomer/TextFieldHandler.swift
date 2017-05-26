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
    var completion: textFieldEnd!
    
    init(_textField: UITextField) {
        super.init()
        
        self.textField = _textField
        self.textField.delegate = self
        self.textField.addTarget(self, action: #selector(textFieldDidEditing(_:)), for: UIControlEvents.editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: (#selector(didEnd(_:))), name: NSNotification.Name(rawValue: "DISMISS_KEYBOARD"), object: nil)
    }
    
    @objc func didEnd (_ notification: Notification) {
        self.textField.resignFirstResponder()
    }
    
    func textFieldDidEditing(_ textField: UITextField) {
        self.completion(textField.text)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        self.completion(textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.completion(textField.text)
        
        return true
    }
    
    
}

