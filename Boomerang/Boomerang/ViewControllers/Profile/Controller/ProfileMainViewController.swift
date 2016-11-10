//
//  ProfileMainViewController.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 10/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class ProfileMainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var inventoryData = [BoomerCellData]()
    
    func loadData() {
        inventoryData = [
            BoomerCellData(dataPhoto: #imageLiteral(resourceName: "profile_dummy"), dataDescription: "Shirley Schimidt", dataTitle: "São Paulo, SP"),
            BoomerCellData(dataPhoto: #imageLiteral(resourceName: "profile_dummy"), dataDescription: "Donald Trump", dataTitle: "Nova York, NY"),
            BoomerCellData(dataPhoto: #imageLiteral(resourceName: "profile_dummy"), dataDescription: "Shirley Schimidt", dataTitle: "São Paulo, SP"),
            BoomerCellData(dataPhoto: #imageLiteral(resourceName: "profile_dummy"), dataDescription: "Donald Trump", dataTitle: "Nova York, NY"),
            BoomerCellData(dataPhoto: #imageLiteral(resourceName: "profile_dummy"), dataDescription: "Shirley Schimidt", dataTitle: "São Paulo, SP"),
            BoomerCellData(dataPhoto: #imageLiteral(resourceName: "profile_dummy"), dataDescription: "Donald Trump", dataTitle: "Nova York, NY"),
            BoomerCellData(dataPhoto: #imageLiteral(resourceName: "profile_dummy"), dataDescription: "Shirley Schimidt", dataTitle: "São Paulo, SP"),
            BoomerCellData(dataPhoto: #imageLiteral(resourceName: "profile_dummy"), dataDescription: "Donald Trump", dataTitle: "Nova York, NY"),
            BoomerCellData(dataPhoto: #imageLiteral(resourceName: "profile_dummy"), dataDescription: "Shirley Schimidt", dataTitle: "São Paulo, SP"),
            BoomerCellData(dataPhoto: #imageLiteral(resourceName: "profile_dummy"), dataDescription: "Donald Trump", dataTitle: "Nova York, NY")
        ]    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
    }
    
}


extension ProfileMainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.inventoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ProfileHeaderView", for: indexPath)
            return headerView
        }
        
       return UICollectionReusableView()
        
    }
}

extension ProfileMainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = CGFloat(3)
        return CGSize(width: self.view.frame.width/3 - spacing, height: self.view.frame.width/3 - spacing);
    }
}
