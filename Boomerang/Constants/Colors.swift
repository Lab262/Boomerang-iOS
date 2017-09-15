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


extension UIColor {
    
    //MARK: - CHAT MESSAGES COLORS
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
            return UIColor.colorWithHexString("B14997")
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
    
    //MARK: - COLORS TRANSACTION
    static var greyTransactionColor: UIColor  {
        get {
            return UIColor.colorWithHexString("848484")
        }
    }
    static var yellowTransactioColor: UIColor  {
        get {
            return UIColor.colorWithHexString("F6A01F")
        }
    }
    
    //MARK: - COLORS PRINCIPALS BOOMER
    static var purplePrincipalBoomerColor: UIColor  {
        get {
            return UIColor.colorWithHexString("491C3E")
        }
    }
    static var yellowPrincipalBoomerColor: UIColor  {
        get {
            return UIColor.colorWithHexString("F6A01F")
        }
    }
    
    //MARK: - COLORS SEARCH BAR
    static var backgroundSearchColor: UIColor  {
        get {
            return UIColor.colorWithHexString("DCB4D2")
        }
    }
    
    static var textSearchColor: UIColor  {
        get {
            return UIColor.colorWithHexString("905A82")
        }
    }
    
    //MARK: - COLORS CREATE POST
    static var unselectedTextButtonColor: UIColor  {
        get {
            return UIColor.colorWithHexString("903A7B")
        }
    }
    
    static var feedbackTextLabelColor: UIColor  {
        get {
            return UIColor.colorWithHexString("606060")
        }
    }
    
    //MARK: - COLORS TIMELINE
    static var timeColor: UIColor  {
        get {
            return UIColor.colorWithHexString("9DAAB3")
        }
    }
    
    //MARK: - COLORS ONBOARD
    static var purpleTextColor: UIColor  {
        get {
            return UIColor.colorWithHexString("672958")
        }
    }
    
    
}
