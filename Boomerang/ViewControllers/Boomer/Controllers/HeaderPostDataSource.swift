//
//  HeaderPostDataSource.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 03/12/2017.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class HeaderPostDataSource: NSObject {

    var collectionView: UICollectionView?
    var photos: [UIImage] = [UIImage]() {
        didSet {
            collectionView?.isHidden = false
            collectionView?.reloadData()
        }
    }
    
    init(collectionView: UICollectionView) {
        super.init()
        configureCollectionView(collectionView: collectionView)
    }
    
    func configureCollectionView(collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
    }
}

extension HeaderPostDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostPhotoCollectionViewCell.identifier, for: indexPath) as? PostPhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.postPhoto.image = photos[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
}

extension HeaderPostDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.height)
    }
}
