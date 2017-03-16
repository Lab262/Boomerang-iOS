//
//  RecommendedPostTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 14/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class RecommendedPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        collectionView.registerNibFrom(RecommendedPostCollectionViewCell.self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        registerNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension RecommendedPostTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedPostCollectionViewCell.identifier, for: indexPath) as! RecommendedPostCollectionViewCell
        
      
        cell.containerCellView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.07).cgColor
        cell.containerCellView.layer.shadowOpacity = 0.9
        
        cell.containerCellView.layer.shadowOffset = CGSize(width: 0, height: 10)
        cell.containerCellView.layer.shadowRadius = 2
        cell.containerCellView.layer.cornerRadius = 4
        
        cell.containerIconView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 4).cgColor
        cell.containerIconView.layer.shadowOpacity = 10
        
        cell.containerIconView.layer.shadowOffset = CGSize(width: -10, height: 10)
        cell.containerIconView.layer.shadowRadius = 7
        cell.containerIconView.layer.cornerRadius = 4

        
        return cell
    }
}

extension RecommendedPostTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 366, height: 306)
    }
    
}
