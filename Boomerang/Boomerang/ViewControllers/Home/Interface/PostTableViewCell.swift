//
//  PostTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 16/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    static var identifier: String {
        return "postTableCell"
    }
    
    static var cellHeight: CGFloat {
        return 168.0
    }
    
    static var nibName: String {
        return "PostTableViewCell"
    }
    
    var presenter = PostPresenter()
    var delegate: UpdateCellDelegate?
    var selectionDelegate: CollectionViewSelectionDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        registerNib()
        // Initialization code
    }
    
    func reloadCollection(){
        collectionView.reloadData()
    }

    func registerNib(){
        collectionView.registerNibFrom(PostCollectionViewCell.self)
    }}

extension PostTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return presenter.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as! PostCollectionViewCell
    
        cell.presenter.post = presenter.posts[indexPath.row]
        cell.setupCell()
        
        return cell
    }

}

extension PostTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 270*UIView.widthScaleProportion(), height: 227*UIView.heightScaleProportion())
    }
}

extension PostTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectionDelegate?.pushFor(identifier: SegueIdentifiers.homeToDetailThing, sectionPost: SectionPost(rawValue:self.tag)!, didSelectItemAt: indexPath)
        //self.selectionDelegate?.collectionViewDelegate(self, didSelectItemAt: indexPath)
    }
}


extension PostTableViewCell: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint)!
        
        print(visibleIndexPath)
    }
}


