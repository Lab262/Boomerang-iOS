//
//  SelectionDelegate.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 02/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

protocol TableViewSelectionDelegate: class {
    
    func tableViewDelegate(_ tableViewDelegate: UITableViewDelegate, didSelectRowAt indexPath: IndexPath)
}

protocol CollectionViewSelectionDelegate: class {
    
    func pushFor(identifier: String, sectionPost: SectionPost?, didSelectItemAt indexPath: IndexPath?)
    
    func callSearchFriendsController()
}
