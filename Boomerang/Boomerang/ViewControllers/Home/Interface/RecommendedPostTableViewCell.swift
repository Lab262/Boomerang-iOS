//
//  RecommendedPostTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 14/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class RecommendedPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postCollectionView: UICollectionView!
    @IBOutlet weak var indexCollectionView: UICollectionView!
    
    
    var arrayCells = [1, 1, 1]
    
    static var identifier: String {
        return "recommendedCell"
    }
    
    static var cellHeight: CGFloat {
        return 168.0
    }
    
    static var nibName: String {
        return "RecommendedPostTableViewCell"
    }
    
    func registerNib(){
        postCollectionView.registerNibFrom(RecommendedPostCollectionViewCell.self)
        indexCollectionView.registerNibFrom(PageControlCollectionViewCell.self)
    }
    
    let spaceCells: CGFloat = 2
    let sizeCells: Int = 8
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let totalWidth: CGFloat = CGFloat((self.arrayCells.count * sizeCells))
        
        let totalSpacing = CGFloat(self.arrayCells.count-1) * spaceCells
        
        let caculationFinal: CGFloat = (totalWidth + totalSpacing)/2
        
        registerNib()
        
        (indexCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset = UIEdgeInsets(top: 0, left: self.bounds.width/2 - caculationFinal, bottom: 0, right: 0)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func generatePostCell (_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedPostCollectionViewCell.identifier, for: indexPath) as! RecommendedPostCollectionViewCell
        
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
        
        return self.arrayCells.count
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

//extension ProductCatalogTableViewCell: UICollectionViewDataSource {
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return photos.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        let cell: UICollectionViewCell
//        
//        switch collectionView {
//        case imagesCollectionView: cell = generateImageCell(collectionView, cellForItemAt: indexPath)
//        case indexCollectionView: cell = generateIndexCell(collectionView, cellForItemAt: indexPath)
//        default: cell = UICollectionViewCell()
//        }
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if collectionView == indexCollectionView {
//            if indexPath.item == selectedPage {
//                let cell = cell as! PageIndexCollectionViewCell
//                cell.changeToSelectedStyle()
//            }
//        }
//    }
//}
//
//extension ProductCatalogTableViewCell: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == indexCollectionView {
//            (collectionView.cellForItem(at: indexPath) as! PageIndexCollectionViewCell).changeToSelectedStyle()
//            selectedPage = indexPath.item
//            isChangingPages = true
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if collectionView == indexCollectionView {
//            if let cell = collectionView.cellForItem(at: indexPath) as? PageIndexCollectionViewCell {
//                cell.changeToUnselectedStyle()
//            }
//        }
//    }
//    
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        updatePageIndex()
//        isChangingPages = false
//    }
//    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if imagesCollectionView.indexPathsForSelectedItems == nil {
//            updatePageIndex()
//        } else if imagesCollectionView.indexPathsForSelectedItems!.isEmpty {
//            updatePageIndex()
//        }
//    }
//    
//    func updatePageIndex() {
//        
//        if let indexPath = (imagesCollectionView.collectionViewLayout as! CenterCellCollectionViewFlowLayout).currentIndexPath {
//            
//            let currentPage = indexPath.item
//            if currentPage != selectedPage {
//                selectedPage = currentPage
//            }
//        }
//        
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if !isChangingPages {
//            updatePageIndex()
//        }
//    }
//}
//
//extension ProductCatalogTableViewCell: UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let size: CGSize
//        
//        switch collectionView {
//        case imagesCollectionView: size = sizeForImageCell
//        case indexCollectionView: size = sizeForIndexCell
//        default: size = CGSize()
//        }
//        
//        return size
//    }
//}

