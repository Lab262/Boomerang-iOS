//
//  PhotoThingTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 20/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class PhotoThingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postIconImage: UIImageView!
    @IBOutlet weak var heightIconConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthIconConstraint: NSLayoutConstraint!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    static var identifier: String {
        return "photoThingCell"
    }
    
    static var cellHeight: CGFloat {
        return 254.0
    }
    
    static var nibName: String {
        return "PhotoThingTableViewCell"
    }
    
    @IBOutlet weak var viewPages: UIView!
    var pageIndicatorView: PageIndicatorView?
    var presenter: PhotoThingPresenter = PhotoThingPresenter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerNib()
        ApplicationState.sharedInstance.delegate = self
        presenter.setViewDelegate(view: self)
        initializePageIndicatorView()
        (photoCollectionView.collectionViewLayout as! CenterCellCollectionViewFlowLayout).centerCellInset = CGPoint(x: 15, y: 0)
    }
    
    func registerNib(){
        photoCollectionView.registerNibFrom(PhotoThingCollectionViewCell.self)
    }
    
    func initializePageIndicatorView(){
        pageIndicatorView = PageIndicatorView(frame: viewPages.frame)
        pageIndicatorView?.delegate = self
        viewPages.addSubview(pageIndicatorView!)
        pageIndicatorView?.centerXAnchor.constraint(equalTo: viewPages.centerXAnchor).isActive = true
        pageIndicatorView?.centerYAnchor.constraint(equalTo: viewPages.centerYAnchor).isActive = true
        pageIndicatorView?.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension PhotoThingTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoThingCollectionViewCell.identifier, for: indexPath) as! PhotoThingCollectionViewCell
        
        cell.thingImage.image = presenter.getImagePostByIndex(indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageIndicatorView?.reload()
    
        return 1
    }
}

extension PhotoThingTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension PhotoThingTableViewCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let flowLayout = (photoCollectionView.collectionViewLayout as! UICollectionViewFlowLayout)
        
        let indexPath = self.photoCollectionView.indexPathForItem(at: self.photoCollectionView.contentOffset + CGPoint(x: flowLayout.sectionInset.left, y: flowLayout.sectionInset.top) + CGPoint(x: photoCollectionView.frame.width/2, y: 0))
        
        if let index = indexPath {
            pageIndicatorView?.selectedPage = index.row
        }
    }
}

extension PhotoThingTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 345*UIView.widthScaleProportion(), height: 291*UIView.widthScaleProportion())
    }
}

extension PhotoThingTableViewCell: UpdatePostDelegate {
    
    func updateRelationsPost(post: Post?, success: Bool, updateType: UpdateType) {
        
        if let postUpdated = post {
            presenter.post = postUpdated
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

extension PhotoThingTableViewCell: PhotoThingDelegate {
    
    func reload(){
        presenter.getIconPost(iconImage: postIconImage, height: heightIconConstraint, width: widthIconConstraint)
        photoCollectionView.reloadData()
        pageIndicatorView?.reload()
    }
    
    func showMessage(msg: String) {
        
    }
}

extension PhotoThingTableViewCell: PageIndicatorViewDelegate {
    
    var numberOfPages: Int {
        return presenter.post!.countPhotos
    }
    
    var indicatorHeight: CGFloat {
        return 6.0
    }
    
    var defaultWidth: CGFloat {
        return 7.0
    }
    
    var selectedWidth: CGFloat {
        return 20.0
    }
    
    var defaultAlpha: CGFloat {
        return 0.5
    }
    
    var selectedAlpha: CGFloat {
        return 1.0
    }
    
    var animationDuration: Double {
        return 0.2
    }
    
    var indicatorsColor: UIColor {
        return UIColor.colorWithHexString("FFFFFF")
    }
    
    var stackViewConfig: (axis: UILayoutConstraintAxis, alignment: UIStackViewAlignment, distribution: UIStackViewDistribution, spacing: CGFloat) {
        
        return (.horizontal, alignment: .center, distribution: .equalSpacing, spacing: 5.0)
    }
}

