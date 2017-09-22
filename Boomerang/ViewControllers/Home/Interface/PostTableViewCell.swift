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
        setupViewDelegate()
    }
    
    func registerNib(){
        collectionView.registerNibFrom(PostCollectionViewCell.self)
        collectionView.registerNibFrom(SeeMoreCollectionViewCell.self)
        collectionView.registerNibFrom(EmptyFriendsCollectionViewCell.self)
    }
    
    func goToProfile(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        self.selectionDelegate?.pushFor(identifier: SegueIdentifiers.homeToProfile, sectionPost: SectionPost(rawValue:self.tag)!, didSelectItemAt: indexPath)
    }
    
    
    func setupViewDelegate() {
        presenter.setViewDelegate(view: self)
    }
    
    func generatePostCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as! PostCollectionViewCell
        cell.coverImage.image = nil
        cell.presenter.post = presenter.posts[indexPath.row]
        cell.profileButton.tag = indexPath.row
        cell.profileButton.addTarget(self, action: #selector(goToProfile(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func generateSeeMoreCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeeMoreCollectionViewCell.identifier, for: indexPath) as! SeeMoreCollectionViewCell
        
        return cell
    }
    
    func generateEmptyFriendsUserCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyFriendsCollectionViewCell.identifier, for: indexPath) as! EmptyFriendsCollectionViewCell
        
        return cell
    }
}

extension PostTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.posts.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if presenter.posts.count > 0 {
            switch indexPath.row {
            case presenter.posts.endIndex:
                return generateSeeMoreCell(collectionView, cellForItemAt: indexPath)
            default:
                return generatePostCell(collectionView, cellForItemAt: indexPath)
            }
        }else {
            return generateEmptyFriendsUserCell(collectionView, cellForItemAt: indexPath)
        }
    }

}

extension PostTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 270*UIView.widthScaleProportion(), height: 227*UIView.heightScaleProportion())
    }
}

extension PostTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == presenter.posts.endIndex {
            if presenter.posts.count > 0 {
                self.selectionDelegate?.pushFor(identifier: SegueIdentifiers.homeToMorePost, sectionPost: SectionPost(rawValue:self.tag)!, didSelectItemAt: indexPath)
            }else {
                self.selectionDelegate?.callSearchFriendsController()
            }
        } else {
            self.selectionDelegate?.pushFor(identifier: SegueIdentifiers.homeToDetailThing, sectionPost: SectionPost(rawValue:self.tag)!, didSelectItemAt: indexPath)
        }
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

extension PostTableViewCell: ViewDelegate {
    
    func reload() {
        self.collectionView.reloadData()
    }
    
    func showMessageError(msg: String) {
        
    }
}


