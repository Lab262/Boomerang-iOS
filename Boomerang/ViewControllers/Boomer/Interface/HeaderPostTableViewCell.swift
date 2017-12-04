//
//  HeaderPostTableViewCell.swift
//  Boomerang
//
//  Created by Felipe perius on 25/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class HeaderPostTableViewCell: UITableViewCell {

    static var identifier: String {
        return "HeaderPostCell"
    }
    
    static var nibName: String {
        return "HeaderPostTableViewCell"
    }
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addCoverLabel: UILabel!
    @IBOutlet weak var iconCameraImage: UIImageView!
    
    private lazy var headerPostDataSource: HeaderPostDataSource = {
        [unowned self] in
        let dataSource = HeaderPostDataSource(collectionView: self.collectionView)
        return dataSource
    }()
    
    var photos = [UIImage]() {
        didSet {
            headerPostDataSource.photos = photos
            hiddenDefaultElements()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerNib()
    }
    
    func registerNib() {
        collectionView?.registerNibFrom(PostPhotoCollectionViewCell.self)
    }
    
    func hiddenDefaultElements() {
        self.addCoverLabel.isHidden = true
        self.iconCameraImage.isHidden = true
        self.backgroundImageView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
