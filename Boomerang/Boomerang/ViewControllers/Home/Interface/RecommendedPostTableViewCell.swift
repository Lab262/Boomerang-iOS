//
//  RecommendedPostTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 14/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

protocol UpdateCellDelegate {
    func updateCell()
}

class RecommendedPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postCollectionView: UICollectionView!
    @IBOutlet weak var indexCollectionView: UICollectionView!
    weak var selectionDelegate: CollectionViewSelectionDelegate?
    
    let spaceCells: CGFloat = 2
    let sizeCells: Int = 8
    
    var delegate: UpdateCellDelegate?
    
    var presenter = HomePresenter()
    
    static var identifier: String {
        return "recommendedCell"
    }
    
    static var cellHeight: CGFloat {
        return 168.0
    }
    
    static var nibName: String {
        return "RecommendedPostTableViewCell"
    }
    
    func updateCell(){
        setInsetsInCollectionView()
        postCollectionView.reloadData()
        indexCollectionView.reloadData()
    }
    
    func setInsetsInCollectionView(){
        let totalWidth: CGFloat = CGFloat((presenter.getPosts().count * sizeCells))
        let totalSpacing = CGFloat(presenter.getPosts().count-1) * spaceCells
        let caculationFinal: CGFloat = (totalWidth + totalSpacing)/2
        (indexCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset = UIEdgeInsets(top: 0, left: self.bounds.width/2 - caculationFinal, bottom: 0, right: 0)
    }
    
    func registerNib(){
        postCollectionView.registerNibFrom(RecommendedPostCollectionViewCell.self)
        indexCollectionView.registerNibFrom(PageControlCollectionViewCell.self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadPlaceholderImage(#imageLiteral(resourceName: "placeholder_image"), CGRect(x: self.frame.origin.x+10, y: frame.origin.y, width: 345, height: 288))
        registerNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func generatePostCell (_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedPostCollectionViewCell.identifier, for: indexPath) as! RecommendedPostCollectionViewCell
        
        cell.presenter.setPost(post: presenter.getPosts()[indexPath.row])
        cell.setupCell()
        
        unloadPlaceholderImage()
        
        return cell
    }
    
    func generatePageControlCell (_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageControlCollectionViewCell.identifier, for: indexPath) as! PageControlCollectionViewCell
        
        cell.widthPageConstraint.constant = 7
        cell.heightPageConstraint.constant = 6
        cell.layoutIfNeeded()
        collectionView.layoutIfNeeded()
        
        return cell
        
    }
}

extension RecommendedPostTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return presenter.getPosts().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case postCollectionView:
            return generatePostCell(collectionView, cellForItemAt: indexPath)
        case indexCollectionView:
            return generatePageControlCell(collectionView, cellForItemAt: indexPath)
        default:
            return UICollectionViewCell()
        }
        
      
//        cell.containerCellView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.07).cgColor
//        cell.containerCellView.layer.shadowOpacity = 0.9
//        
//        cell.containerCellView.layer.shadowOffset = CGSize(width: 0, height: 10)
//        cell.containerCellView.layer.shadowRadius = 2
//        cell.containerCellView.layer.cornerRadius = 4
//        
//        cell.containerIconView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 4).cgColor
//        cell.containerIconView.layer.shadowOpacity = 10
//        
//        cell.containerIconView.layer.shadowOffset = CGSize(width: -10, height: 10)
//        cell.containerIconView.layer.shadowRadius = 7
//        cell.containerIconView.layer.cornerRadius = 4

        
    }
}


extension RecommendedPostTableViewCell: UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectionDelegate?.collectionViewDelegate(self, didSelectItemAt: indexPath)
    }
    
}


extension RecommendedPostTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case postCollectionView:
            return CGSize(width: 366, height: 306)
        case indexCollectionView:
            return CGSize(width: 8, height: 50)
        default:
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
    }
}

extension RecommendedPostTableViewCell: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        var visibleRect = CGRect()
        visibleRect.origin = postCollectionView.contentOffset
        visibleRect.size = postCollectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = postCollectionView.indexPathForItem(at: visiblePoint)!
        
        if visibleIndexPath.row >= presenter.getPosts().endIndex-1 {
            delegate?.updateCell()
        }
    }
}

