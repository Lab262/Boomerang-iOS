//
//  BoomerThingCollection.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 07/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class BoomerThingCollection: UITableViewCell {
    
    static let cellIdentifier = "BoomerThingCollection"
    @IBOutlet weak var collectionView: UICollectionView!
    
    var thingsData: [BoomerThing]! {
        didSet {
            setupCell()
        }
    }
    
    func setupCell() {
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(
            UINib(nibName: BoomerThingCell.cellIdentifier,
                  bundle: nil),
            forCellWithReuseIdentifier: BoomerThingCell.cellIdentifier)
    }
    
}


extension BoomerThingCollection: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thingsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoomerThingCell.cellIdentifier, for: indexPath) as! BoomerThingCell
        cell.thingData = self.thingsData[indexPath.row]
        
        return cell
    }
    
    
}

extension BoomerThingCollection: UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath)
    }
    
}

