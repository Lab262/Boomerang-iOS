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
    func unload()
}

class RecommendedPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postCollectionView: UICollectionView!
    weak var selectionDelegate: CollectionViewSelectionDelegate?
    
    @IBOutlet weak var viewPages: UIView!
    
    var pageIndicatorView: PageIndicatorView?
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
        
        postCollectionView.reloadData()
        pageIndicatorView?.reload()
    }
    
    func registerNib(){
        postCollectionView.registerNibFrom(RecommendedPostCollectionViewCell.self)
       // indexCollectionView.registerNibFrom(PageControlCollectionViewCell.self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loadPlaceholderImage(#imageLiteral(resourceName: "placeholder_image"), CGRect(x: self.frame.origin.x+10, y: frame.origin.y, width: 345, height: 288))
        registerNib()
        initializePageIndicatorView()
    }
    
    func initializePageIndicatorView(){
        pageIndicatorView = PageIndicatorView(frame: viewPages.frame)
        pageIndicatorView?.delegate = self
        viewPages.addSubview(pageIndicatorView!)
        pageIndicatorView?.centerXAnchor.constraint(equalTo: viewPages.centerXAnchor).isActive = true
        pageIndicatorView?.centerYAnchor.constraint(equalTo: viewPages.centerYAnchor).isActive = true
        pageIndicatorView?.translatesAutoresizingMaskIntoConstraints = false
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
       // case indexCollectionView:
           // return generatePageControlCell(collectionView, cellForItemAt: indexPath)
        default:
            return UICollectionViewCell()
        }
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
      //  case indexCollectionView:
        //    return CGSize(width: 8, height: 50)
        default:
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
    }
}

extension RecommendedPostTableViewCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let flowLayout = (self.postCollectionView.collectionViewLayout as! UICollectionViewFlowLayout)
        
        let indexPath = postCollectionView.indexPathForItem(at: self.postCollectionView.contentOffset + CGPoint(x: flowLayout.sectionInset.left, y: flowLayout.sectionInset.top) + CGPoint(x: postCollectionView.frame.width/2, y: 0))
        
        if let index = indexPath {
            pageIndicatorView?.selectedPage = index.row
        }
    }
    
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

extension RecommendedPostTableViewCell: PageIndicatorViewDelegate {
    
    var numberOfPages: Int {
        return presenter.getPosts().count
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
        return UIColor.colorWithHexString("672958")
    }
    
    var stackViewConfig: (axis: UILayoutConstraintAxis, alignment: UIStackViewAlignment, distribution: UIStackViewDistribution, spacing: CGFloat) {
        
        return (.horizontal, alignment: .center, distribution: .equalSpacing, spacing: 5.0)
    }
}

