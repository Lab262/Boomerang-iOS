//
//  UITableViewCell+Utils.swift
//  SocialNetwork55Lab
//
//  Created by Huallyd Smadi on 12/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

protocol UITableViewCellHelper: class {
    static var cellHeight: CGFloat { get }
    static var identifier: String { get }
    static var nibName: String { get }
}

extension UITableViewCellHelper {
    static var cellHeight: CGFloat {
        return 44.0
    }
    
    static var identifier: String {
        return ""
    }
    
    static var nibName: String {
        return ""
    }
}

extension UITableViewCell: UITableViewCellHelper {
    
    func setSeparatorHidden(_ hidden: Bool) {
        if hidden {
            separatorInset.left = 1000
        } else {
            separatorInset = UIEdgeInsets()
        }
    }
}

extension UITableView {
    
    func registerNibFrom(_ cellClass: UITableViewCell.Type) {
        
        let nibName = cellClass.value(forKey: "nibName") as! String
        let cellIdentifier = cellClass.value(forKey: "identifier") as! String
        
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
}
