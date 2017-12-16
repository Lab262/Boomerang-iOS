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
    weak var selectionDelegate: CollectionViewSelectionDelegate?
    
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
    
    func goToCreatePost(_ sender: UIButton) {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        self.selectionDelegate?.pushFor(identifier: SegueIdentifiers.homeToProfile, sectionPost: .recommended, didSelectItemAt: indexPath)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectionDelegate?.callCreatePostController()
    }
}


extension RecommendedEmptyStateTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: RecommendedPostCollectionViewCell.cellSize.width * UIView.heightScaleProportion(), height: RecommendedPostCollectionViewCell.cellSize.height * UIView.heightScaleProportion())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
    }
}
