//
//  BoomerThingCollection.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 07/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class BoomerThingCollection: UITableViewCell {
    
    weak var selectionDelegate: CollectionViewSelectionDelegate?
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.window?.endEditing(true)
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
        
        //self.selectionDelegate?.collectionViewDelegate(self, didSelectItemAt: indexPath)
        
        print(indexPath)
    }
}

extension BoomerThingCollection: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.height * 1.5, height: self.frame.height / 1);
    }
}

