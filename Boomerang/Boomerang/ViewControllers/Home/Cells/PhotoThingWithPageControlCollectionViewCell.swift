//
//  PhotoThingWithPageControlCollectionViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 20/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class PhotoThingWithPageControlCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thingImage: UIImageView!
    
    static var identifier: String {
        return "photoThingControlCell"
    }
    
    static var cellHeight: CGFloat {
        return 168.0
    }
    
    static var nibName: String {
        return "PhotoThingWithPageControlCollectionViewCell"
    }
    
    var post: Post? {
        didSet{
            updateCellUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCellUI(){
        
    }
    
    func getRelationPhotosByThing(){
        if post!.photos.count > 0 {
            thingImage.image = post?.photos[0]
        } else if !post!.downloadedImages {
            post?.getRelationsInBackgroundWithDataBy(key: "photos", keyFile: "imageFile", completionHandler: { (success, msg, objects, data) in
                
                if success {
                    self.post?.photos.append(UIImage(data: data!)!)
                    if self.post!.photos.count < 2 {
                        self.thingImage.image = UIImage(data: data!)!
                    }
                    self.post?.downloadedImages = true
                } else {
                    
                }
            })
        } else {
            self.thingImage.image = UIImage(named: "foto_dummy")
        }
    }

}

