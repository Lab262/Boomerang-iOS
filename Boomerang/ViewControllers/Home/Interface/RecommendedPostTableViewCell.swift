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
   
    var presenter = PostPresenter()
    
    static var identifier: String {
        return "recommendedCell"
    }

    static var cellHeight: CGFloat {
        return 100
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
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
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
    
    func goToProfile(_ sender: UIButton) {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        self.selectionDelegate?.pushFor(identifier: SegueIdentifiers.homeToProfile, sectionPost: .recommended, didSelectItemAt: indexPath)
    }
    
    func generatePostCell (_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedPostCollectionViewCell.identifier, for: indexPath) as! RecommendedPostCollectionViewCell
        
        cell.postImage.image = nil
        cell.presenter.post = presenter.posts[indexPath.row]
        cell.profileButton.addTarget(self, action: #selector(goToProfile(_:)), for: .touchUpInside)
        cell.profileButton.tag = indexPath.row
        
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
        
        return presenter.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case postCollectionView:
            return generatePostCell(collectionView, cellForItemAt: indexPath)
        default:
            return UICollectionViewCell()
        }
    }
}


extension RecommendedPostTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectionDelegate?.pushFor(identifier: SegueIdentifiers.homeToDetailThing, sectionPost: .recommended, didSelectItemAt: indexPath)
    }
}


extension RecommendedPostTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case postCollectionView:
            return CGSize(width: RecommendedPostCollectionViewCell.cellSize.width * UIView.heightScaleProportion(), height: RecommendedPostCollectionViewCell.cellSize.height * UIView.heightScaleProportion())
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
        
        //GABIARRAAAAAAAA CONSERTAAAAA
        if UIScreen.main.bounds.width == 320.0 {
            let indexPath2 = postCollectionView.indexPathForItem(at: self.postCollectionView.contentOffset + CGPoint(x: flowLayout.sectionInset.left, y: flowLayout.sectionInset.top) + CGPoint(x: postCollectionView.frame.width/2, y: 0)+CGPoint(x: 0, y: 19.5))
            
            if let index = indexPath2 {
                pageIndicatorView?.selectedPage = index.row
            }
        }
        
        if let index = indexPath {
            pageIndicatorView?.selectedPage = index.row
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        var visibleRect = CGRect()
//        visibleRect.origin = postCollectionView.contentOffset
//        visibleRect.size = postCollectionView.bounds.size
//        
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//        let visibleIndexPath: IndexPath = postCollectionView.indexPathForItem(at: visiblePoint)!
//        
//        if visibleIndexPath.row >= presenter.posts.endIndex-1 {
//            delegate?.updateCell()
//        }
    }
}

extension RecommendedPostTableViewCell: PageIndicatorViewDelegate {
    
    var numberOfPages: Int {
        return presenter.posts.count
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

