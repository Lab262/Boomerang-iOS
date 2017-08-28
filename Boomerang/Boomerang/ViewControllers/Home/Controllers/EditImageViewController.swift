//
//  EditImageViewController.swift
//  Boomerang
//
//  Created by Felipe perius on 26/08/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class EditImageViewController: UIViewController {
    
    var allImages = [UIImage]()
    var photo:UIImage?

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        collectionView.reloadData()
        self.registerNib()
    }
    func registerNib(){
        collectionView.registerNibFrom(EditPhotoCollectionViewCell.self)
    }
}

extension EditImageViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photo != nil {
            return 1
        }
        if allImages.isEmpty {
            return 0
        }
        
        return allImages.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditPhotoCollectionViewCell.identifier, for: indexPath) as! EditPhotoCollectionViewCell
        cell.image = self.photo
        
        return cell
    }


}
