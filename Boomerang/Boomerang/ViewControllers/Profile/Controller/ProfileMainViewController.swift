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
    
    var presenter = ProfilePresenter()
    
    override func viewWillAppear(_ animated: Bool) {
        TabBarController.mainTabBarController.showTabBar()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setControllerDelegate(controller: self)
        presenter.getPostsOfUser()
        
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
        
        return presenter.getAllPosts().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfilePostCollectionViewCell.identifier, for: indexPath) as! ProfilePostCollectionViewCell
        
        cell.presenter.setPost(post: presenter.getAllPosts()[indexPath.row])
        cell.updatePostCell()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ProfileHeaderView", for: indexPath) as! ProfileCollectionReusableView
            
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint)!
        
        if visibleIndexPath.row >= presenter.getAllPosts().endIndex-1 {
            presenter.updatePosts()
        }
    }
    
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

extension ProfileMainViewController: ViewDelegate {
    
    func reload() {
        if presenter.getAllPosts().count != presenter.getCurrentPostsCount(){
            collectionView.reloadData()
        }
    }
    
    func showMessageError(msg: String) {
        
    }
}

