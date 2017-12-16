//
//  RecommendedEmptyStateTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 16/12/2017.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class RecommendedEmptyStateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    static var identifier: String {
        return "recommendedEmptyStateCell"
    }
    
    static var cellHeight: CGFloat {
        return 100
    }
    
    static var nibName: String {
        return "RecommendedEmptyStateTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        registerNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func registerNib(){
        collectionView.registerNibFrom(EmptyFriendsCollectionViewCell.self)
    }
    
    func generateEmptyFriendsUserCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyFriendsCollectionViewCell.identifier, for: indexPath) as! EmptyFriendsCollectionViewCell
        
        cell.titleLabel.text = "Adicione posts."
        cell.messageLabel.text = "O aplicativo ainda não possui posts. Adicione posts, e comece os arremessos."
        
        return cell
    }
}

extension RecommendedEmptyStateTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return generateEmptyFriendsUserCell(collectionView, cellForItemAt: indexPath)
    }
}


extension RecommendedEmptyStateTableViewCell: UICollectionViewDelegate {

}


extension RecommendedEmptyStateTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: RecommendedPostCollectionViewCell.cellSize.width * UIView.heightScaleProportion(), height: RecommendedPostCollectionViewCell.cellSize.height * UIView.heightScaleProportion())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
    }
}
