//
//  UIFontExtension.swift
//  Boomerang
//
//  Created by Luís Resende on 04/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

extension UIFont {
    
    class func montserratBold(size:CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Bold", size: size)!
    }
    
    class func montserratSemiBold(size:CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-SemiBold", size: size)!
    }
    
    class func montserratLight(size:CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Light", size: size)!
    }
    
    class func montserratRegular(size:CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Regular", size: size)!
    }
    
    class func montserratBlack(size:CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Black", size: size)!
    }
}
