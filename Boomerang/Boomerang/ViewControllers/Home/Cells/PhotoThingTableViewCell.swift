//
//  PhotoThingTableViewCell.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 20/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class PhotoThingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    static var identifier: String {
        return "photoThingCell"
    }
    
    static var cellHeight: CGFloat {
        return 254.0
    }
    
    static var nibName: String {
        return "PhotoThingTableViewCell"
    }
    
    var post: Post? {
        didSet{
            getCountPhotos()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        registerNib()
        // Initialization code
    }
    
    func registerNib(){
        collectionView.registerNibFrom(PhotoThingWithPageControlCollectionViewCell.self)
    }
    
    
    func getCountPhotos() {
        if post!.countPhotos < 1 {
            post!.getRelationCountInBackgroundBy(key: "photos", completionHandler: { (success, msg, count) in
                if success {
                    self.post!.countPhotos = count!
                    self.collectionView.reloadData()
                } else {
                    
                }
            })
        }
    }
    
    func getRelationPhotosByThing(){
        var doNotDownload = [Photo]()
        if post!.relations != nil {
            for relation in post!.relations! {
                if relation.photo != nil {
                    doNotDownload.append(relation)
                }
            }
        }
        
        post?.getRelationsInBackgroundBy(key: "photos", keyColunm: "photos", isNotContained: true, notContainedKeys: doNotDownload, completionHandler: { (success, msg, objects) in
            
            if success {
                self.post?.relations = [Photo]()
                for object in objects! {
                    let relation = Photo(object: object)
                    self.post?.relations?.append(relation)
                }
                
            } else {
                
            }
            
        })
    }
    
    
    func getImagePostByIndex(_ index: Int) -> UIImage {
        
        if post!.photos.count > 0 && post!.photos.count >= index+1 {
            return post!.photos[index]
        } else {
            return #imageLiteral(resourceName: "placeholder_image")
        }
        
    }
}

extension PhotoThingTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoThingWithPageControlCollectionViewCell.identifier, for: indexPath) as! PhotoThingWithPageControlCollectionViewCell
        
        cell.thingImage.image = getImagePostByIndex(indexPath.row)
        
        if cell.thingImage.image == #imageLiteral(resourceName: "placeholder_image") {
            self.getRelationPhotosByThing()
        }
        
        func getRelationPhotosByThing(){
            var doNotDownload = [Photo]()
            
            if post!.relations != nil {
                for relation in post!.relations! {
                    if relation.photo != nil {
                        doNotDownload.append(relation)
                    }
                }
            }
            
            post?.getRelationsInBackgroundBy(key: "photos", keyColunm: "photos", isNotContained: true, notContainedKeys: doNotDownload, completionHandler: { (success, msg, objects) in
                
                if success {
                    self.post?.relations = [Photo]()
                    for object in objects! {
                        let relation = Photo(object: object)
                        self.post?.relations?.append(relation)
                    }
                    
                    for photo in self.post!.relations! {
                        photo.getDataInBackgroundBy(key: "imageFile", completionHandler: { (success, msg, data) in
                            if success{
                                photo.photo = UIImage(data: data!)
                                cell.thingImage.image = UIImage(data: data!)
                            } else {
                                print ("NO SUCCESS IN DOWNLOAD")
                            }
                        })
                    }
                } else {
                 print ("NO SUCCESS IN RELATION")
                }
                
            })
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post!.countPhotos
    }
}

extension PhotoThingTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension PhotoThingTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 345, height: 291)
    }
}


