//
//  UILabelExtension.swift
//  Boomerang
//
//  Created by Luís Resende on 17/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

extension UILabel {
    func setDynamicFont() {
        self.font = UIFont(name: self.font.fontName, size: UIView.heightScaleProportion()*self.font.pointSize)!
    }
}
