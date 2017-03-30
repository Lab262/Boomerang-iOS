//
//  PhotoThingTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 20/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class PhotoThingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    static var identifier: String {
        return "photoThingCell"
    }
    
    static var cellHeight: CGFloat {
        return 254.0
    }
    
    static var nibName: String {
        return "PhotoThingTableViewCell"
    }
    
    var presenter: DetailThingPresenter = DetailThingPresenter()
   
    override func awakeFromNib() {
        super.awakeFromNib()
        registerNib()
        ApplicationState.sharedInstance.delegate = self
        presenter.setControllerDelegate(controller: self)
    }
    
    func registerNib(){
        collectionView.registerNibFrom(PhotoThingWithPageControlCollectionViewCell.self)
    }
}

extension PhotoThingTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoThingWithPageControlCollectionViewCell.identifier, for: indexPath) as! PhotoThingWithPageControlCollectionViewCell
        
        cell.thingImage.image = presenter.getImagePostByIndex(indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getPost().countPhotos
    }
}

extension PhotoThingTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension PhotoThingTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 345, height: 291)
    }
}

extension PhotoThingTableViewCell: UpdatePostDelegate {
    
    func updateRelationsPost(post: Post?, success: Bool, updateType: UpdateType) {
        
        if let postUpdated = post {
            presenter.setPost(post: postUpdated)
        }
        
        switch updateType {
        case .amount:
            presenter.getCountPhotos(success: success)
        case .relation:
            presenter.getRelationsImages(success: success)
        case .download:
            presenter.downloadImagesPost(success: success)
        }
    }
}

extension PhotoThingTableViewCell: ViewControllerDelegate {
    
    func reload(array: [Any]?) {
        collectionView.reloadData()
    }
    
    func showMessageError(msg: String) {
        
    }
}
