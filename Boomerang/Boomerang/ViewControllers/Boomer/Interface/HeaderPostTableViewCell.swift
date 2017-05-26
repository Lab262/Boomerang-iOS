//
//  HeaderPostTableViewCell.swift
//  Boomerang
//
//  Created by Felipe perius on 25/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class HeaderPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var touchAreaThrowButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var anexPhotoButton: UIButtonWithPicker!
    @IBOutlet weak var throwButton: UIButton!
    @IBOutlet weak var photo: UIImageView!
    var delegate: UIIButtonWithPickerDelegate? = nil
    var highlights: [UIImage] = []
    
    static var identifier: String {
        return "HeaderPostCell"
    }
    
    static var nibName: String {
        return "HeaderPostTableViewCell"
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerNibs()
        self.configureLabel()
        titleLabel.setDynamicFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureLabel(){
        let title = titleLabel.text?.with(characterSpacing: 1.67, color:titleLabel.textColor)
        titleLabel.attributedText = title
    }

    func registerNibs() {
        collectionView.registerNibFrom(HighlightCollectionViewCell.self)
    }
    
}

extension HeaderPostTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return HighlightCollectionViewCell.cellSize
    }
}
extension HeaderPostTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return highlights.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HighlightCollectionViewCell.identifier, for: indexPath) as! HighlightCollectionViewCell
        
        cell.anexPhotoButton.delegate = self.delegate
        cell.imageView.image = highlights[indexPath.item]
        
        return cell
    }
}
