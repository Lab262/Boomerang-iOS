//
//  Colors.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 09/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

extension UIColor {

    static var menuBackgroundColor: UIColor  {
        get {
                return UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1)
        }
    }
    
    static var unselectedButtonTextColor: UIColor  {
        get {
            return UIColor.colorWithHexString("BDBDBD")
        }
    }
    
    static var selectedButtonTextColor: UIColor  {
        get {
            return UIColor.white
        }
    }
    
  
}

//MARK: - CHAT MESSAGES COLORS
extension UIColor {
    
    static var myMessageChatTextColor: UIColor  {
        get {
            return UIColor.colorWithHexString("FFFFFF")
        }
    }
    static var myMessageChatBorderColor: UIColor  {
        get {
            return UIColor.colorWithHexString("2C2C2C")
        }
    }
    static var myMessageChatBackgroundColor: UIColor  {
        get {
            return UIColor.colorWithHexString("672958")
        }
    }
    static var friendMessageChatTextColor: UIColor  {
        get {
            return UIColor.colorWithHexString("000000")
        }
    }
    static var friendMessageChatBackgroundColor: UIColor  {
        get {
            return UIColor.colorWithHexString("FAFAFA")
        }
    }
    static var friendMessageChatBorderColor: UIColor  {
        get {
            return UIColor.colorWithHexString("E0E0E0")
        }
    }
    static var yellowBoomerColor: UIColor  {
        get {
            return UIColor.colorWithHexString("FBBB47")
        }
    }
    
}
