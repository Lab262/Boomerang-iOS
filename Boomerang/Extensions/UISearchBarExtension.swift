//
//  UISearchBarExtension.swift
//  Boomerang
//
//  Created by Luís Resende on 22/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

extension UISearchBar {
    func setBackgroundSearchBarColor(color : UIColor) {
        for subView in self.subviews {
            for subSubView in subView.subviews {
                
                if let _ = subSubView as? UITextInputTraits {
                    let textField = subSubView as! UITextField
                    textField.backgroundColor = color
                    break
                }
                
            }
        }
    }
    
    func setPlaceholderSearchBarColor(color : UIColor) {
        let placeholderAttributes: [String : AnyObject] = [NSForegroundColorAttributeName: color, NSFontAttributeName: UIFont.systemFont(ofSize: UIFont.systemFontSize)]
        let attributedPlaceholder: NSAttributedString = NSAttributedString(string: SearchBarTitles.placeholder, attributes: placeholderAttributes)
        let textFieldPlaceHolder = self.value(forKey: "searchField") as? UITextField
        textFieldPlaceHolder?.attributedPlaceholder = attributedPlaceholder
    }
    
    func setTextSearchBarColor(color : UIColor) {
        let clrChange = subviews.flatMap { $0.subviews }
        guard let sc = (clrChange.filter { $0 is UITextField }).first as? UITextField else { return }
        sc.textColor = color
    }
    
    func setIconSearchBarColor(color : UIColor) {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let imageV = textFieldInsideSearchBar?.leftView as! UIImageView
        imageV.image = imageV.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imageV.tintColor = color
    }
    
    func setClearIconSearchBarColor(color : UIColor) {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        
        let clearButton = textFieldInsideSearchBar?.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton.tintColor = color
    }
    
    func setCursorSearchBarColor(color : UIColor) {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.tintColor = color
    }

    @IBInspectable var defaultTheme: Bool {
        get {
            return true
        }
        set {
            if newValue == true {
                self.setBackgroundImage(ViewUtil.imageFromColor(.clear, forSize:self.frame.size, withCornerRadius: 0), for: .any, barMetrics: .default)
                self.setBackgroundSearchBarColor(color: UIColor.backgroundSearchColor)
                self.setCursorSearchBarColor(color: UIColor.textSearchColor)
                self.setPlaceholderSearchBarColor(color: UIColor.textSearchColor)
                self.setTextSearchBarColor(color: UIColor.textSearchColor)
                self.setIconSearchBarColor(color: UIColor.textSearchColor)
                self.setClearIconSearchBarColor(color: UIColor.textSearchColor)
            }
        }
    }

}
