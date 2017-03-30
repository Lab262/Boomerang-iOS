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
    
    var post: Post?

    override func awakeFromNib() {
        super.awakeFromNib()
        registerNib()
        ApplicationState.sharedInstance.delegate = self
    }
    
    func registerNib(){
        collectionView.registerNibFrom(PhotoThingWithPageControlCollectionViewCell.self)
    }
    
    func getRelationsImages(success: Bool){
        if !success {
            PostRequest.getRelationsInBackground(post: post!, completionHandler: { (success, msg) in
                if success {
                    self.downloadImagesPost(success: true)
                } else {
                    print ("RELATIONS REQUEST ERROR")
                }
            })
        }
    }
    
    func getCountPhotos(success: Bool){
        if success {
            collectionView.reloadData()
        } else {
            post!.getRelationCountInBackgroundBy(key: "photos", completionHandler: { (success, msg, count) in
                if success {
                    self.post!.countPhotos = count!
                    self.collectionView.reloadData()
                } else {
                    print ("COUNT PHOTOS REQUEST ERROR")
                }
            })
        }
    }
    
    func downloadImagesPost(success:Bool) {
        if let relations = post!.relations {
            for relation in relations where !relation.isDownloadedImage {
                relation.getDataInBackgroundBy(key: "imageFile", completionHandler: { (success, msg, data) in
                    if success {
                        relation.photo = UIImage(data: data!)
                        relation.isDownloadedImage = true
                        self.collectionView.reloadData()
                    } else {
                        print ("DOWNLOAD IMAGES ERRO")
                    }
                })
            }
        }
    }

    func getImagePostByIndex(_ index: Int) -> UIImage {
        if let relations = self.post?.relations {
            if relations.count >= index+1 {
                if let photo = relations[index].photo {
                    return photo
                } else {
                    return #imageLiteral(resourceName: "placeholder_image")
                }
            } else {
                return #imageLiteral(resourceName: "placeholder_image")
            }
        } else {
            return #imageLiteral(resourceName: "placeholder_image")
        }
    }
}

extension PhotoThingTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoThingWithPageControlCollectionViewCell.identifier, for: indexPath) as! PhotoThingWithPageControlCollectionViewCell
        
        cell.thingImage.image = getImagePostByIndex(indexPath.row)
        
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

extension PhotoThingTableViewCell: UpdatePostDelegate {
    
    func updateRelationsPost(post: Post?, success: Bool, updateType: UpdateType) {
        
        if let postUpdated = post {
            self.post = postUpdated
        }
        
        switch updateType {
        case .amount:
            getCountPhotos(success: success)
        case .relation:
            getRelationsImages(success: success)
        case .download:
            downloadImagesPost(success: success)
        }
    }
}
