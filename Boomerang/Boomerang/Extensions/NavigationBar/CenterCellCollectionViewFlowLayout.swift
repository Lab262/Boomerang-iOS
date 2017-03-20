//
//  CenterCellCollectionViewFlowLayout.swift
//  CenterCellCollectionView
//
//  Created by Huallyd Smadi on 23/11/2015.
//  Copyright (c) 2015 Huallyd Smadi. All rights reserved.
//

import UIKit

class CenterCellCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    @IBInspectable var centerOffset = CGPoint()
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let targetContentOffset: CGPoint
        
        if let cv = self.collectionView {
            
            let isGoingLeftMultiplier =  (velocity.x == 0) ? 0 : ((velocity.x < 0) ? -1 : 1)
            
            let offsetLocation = cv.contentOffset + CGPoint(x: sectionInset.left, y: sectionInset.top) + centerOffset
            let currentIndexPath = indexPath(in: cv, at: offsetLocation)
            
            if let currentIndexPath = currentIndexPath {
                
                let proposedIndex = currentIndexPath.item + (1 * isGoingLeftMultiplier)
                let proposedIndexPath = IndexPath(item: proposedIndex, section: 0)
                
                // If the proposed index is between 0 and Max, it is valid
                if proposedIndex >= 0 || proposedIndex <= (cv.numberOfItems(inSection: 0) - 1) {
                    
                    let proposedCell = validCell(in: cv, doubty: proposedIndexPath, valid: currentIndexPath)
                    
                    let offsetX = proposedCell.frame.origin.x - sectionInset.left
                    targetContentOffset = CGPoint(x: offsetX, y: proposedContentOffset.y)
                    
                } else {
                    targetContentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
                }
                
            } else {
                targetContentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
            }
            
        } else {
            targetContentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
        
        return targetContentOffset
    }
    
    private func validCell(in collectionView: UICollectionView, doubty doubtyIndexPath: IndexPath, valid validIndexPath: IndexPath) -> UICollectionViewCell {
        
        let validCell: UICollectionViewCell
        
        if let cell = collectionView.cellForItem(at: doubtyIndexPath) {
            validCell = cell
        } else {
            validCell = collectionView.cellForItem(at: validIndexPath)!
        }
        
        return validCell
    }
    
    private func indexPath(in collectionView: UICollectionView, at offsetLocation: CGPoint) -> IndexPath? {
        
        var currentIndexPath: IndexPath?
        
        if let ci = collectionView.indexPathForItem(at: offsetLocation) {
            
            currentIndexPath = ci
            
        } else if let cell = closestCell(to: offsetLocation, collectionView) {
            
            let ci = collectionView.indexPath(for: cell)!
            currentIndexPath = ci
        }
        
        return currentIndexPath
    }
    
    private func closestCell(to point: CGPoint, _ collectionView: UICollectionView) -> UICollectionViewCell? {
        let cells = collectionView.visibleCells
        
        guard cells.count > 0 else {
            return nil
        }
        
        var closestCell: UICollectionViewCell = cells[0]
        
        for i in 1..<cells.count {
            let cell = cells[i]
            
            if point.distance(to: cell.frame.origin) < point.distance(to: closestCell.frame.origin) {
                closestCell = cell
            }
        }
        
        return closestCell
    }
    
    
}
