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
   var completion: textViewEnd!
   var numberOfRows:CGFloat = 4
   var placeholder : String?
   
   
   init(textView: UITextView) {
      
      super.init()
      
      self.textView = textView
      self.textView?.delegate = self
      self.textView?.isEditable = true
      self.placeholder = textView.text
      
      NotificationCenter.default.addObserver(self, selector: (#selector(TextViewHandler.didEnd(_:))), name: NSNotification.Name(rawValue: "DISMISS_KEYBOARD"), object: nil)
      
   }
   
   func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
      
      textView.resignFirstResponder()
      
      return true
   }
   
   func textFieldDidEditing(_ textView: UITextView) {
      self.completion(textView.text)
   }
   
   
   func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      
      if text != "\n"{
         let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
         
         var textWidth: CGFloat = UIEdgeInsetsInsetRect(textView.frame, textView.textContainerInset).width
         
         textWidth -= 2.0 * textView.textContainer.lineFragmentPadding
         
         let boundingRect: CGRect = newText.boundingRect(with: CGSize(width: textWidth, height: 0), options: [NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading], attributes: [NSFontAttributeName: textView.font!], context: nil)
         
         let numberOfLines = boundingRect.height / textView.font!.lineHeight
         self.completion(textView.text)
         return numberOfLines <= self.numberOfRows
         
      }else {
         textView.resignFirstResponder()
         return true
      }
   }
   
   
   @objc func didEnd (_ notification: Notification) {
      self.textView?.resignFirstResponder()
   }
   
   
   func textViewDidMiss (_ textView: UITextView) {
      self.textViewDidEndEditing(textView)
   }
   
   func textViewDidBeginEditing(_ textView: UITextView) {
      if textView.text == self.placeholder {
         textView.text = ""
      }
   }
   
   func textViewDidEndEditing(_ textView: UITextView) {
      textView.resignFirstResponder()
   }
   
   func textFieldShouldReturn(_ textView: UITextView) -> Bool {
      textView.resignFirstResponder()
      return true
   }
   
}
