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
    
    func collectionViewDelegate(_ colletionViewDelegate: UICollectionViewDelegate, didSelectItemAt indexPath: IndexPath)
    
    func pushFor(identifier: String)
}
