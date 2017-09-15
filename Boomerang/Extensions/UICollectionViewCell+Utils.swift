//
//  UICollectionViewCell+Utils.swift
//  SocialNetwork55Lab
//
//  Created by Huallyd Smadi on 13/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

import UIKit

protocol UICollectionViewCellHelper: class {
    static var cellSize: CGSize { get }
    static var identifier: String { get }
    static var nibName: String { get }
}

extension UICollectionViewCellHelper {
    static var cellSize: CGSize {
        return CGSize(width: 50.0, height: 50.0)
    }
    
    static var identifier: String {
        return ""
    }
    
    static var nibName: String {
        return ""
    }
}

extension UICollectionViewCell: UICollectionViewCellHelper {
    
    func changeToSelectedStyle() {
        
    }
    
    func changeToUnselectedStyle() {
        
    }
}

extension UICollectionView {
    
    func registerNibFrom(_ cellClass: UICollectionViewCell.Type) {
        
        let nibName = cellClass.value(forKey: "nibName") as! String
        let cellIdentifier = cellClass.value(forKey: "identifier") as! String
        
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
}

