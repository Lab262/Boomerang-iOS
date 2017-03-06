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
    @IBOutlet weak var parallaxBackgroundHeightConstraint: NSLayoutConstraint!
    internal var lastContentOffset: CGFloat = 0
    internal var backgroundIsFreezy = false
    
    var user = ApplicationState.sharedInstance.currentUser
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ProfileHeaderView", for: indexPath) as! ProfileCollectionReusableView
            
            headerView.user = user
            
            return headerView
        }
        
       return UICollectionReusableView()
        
    }
}

extension ProfileMainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = CGFloat(0)
        return CGSize(width: self.view.frame.width/3 - spacing, height: self.view.frame.width/3 - spacing);
    }
}

extension ProfileMainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (self.lastContentOffset > scrollView.contentOffset.y) {
//            print("down")
                   }
        else if (self.lastContentOffset < scrollView.contentOffset.y) {
//            print("up")
 
        }

        if scrollView.contentOffset.y <= 0 {
            self.parallaxBackgroundHeightConstraint.constant = self.parallaxBackgroundHeightConstraint.constant + (self.lastContentOffset - scrollView.contentOffset.y)
        } else {
            self.parallaxBackgroundHeightConstraint.constant = 155
        }
        
        if self.parallaxBackgroundHeightConstraint.constant > 155 && scrollView.contentOffset.y >= 0  {
            self.parallaxBackgroundHeightConstraint.constant = 155
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
        
        self.lastContentOffset = scrollView.contentOffset.y
   
    }

    
}

