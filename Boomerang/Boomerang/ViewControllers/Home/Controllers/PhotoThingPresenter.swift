//
//  PhotoThingPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 30/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit


protocol PhotoThingDelegate {
    func reload()
    func showMessage(msg: String)
}

class PhotoThingPresenter: NSObject {
    fileprivate var post:Post? = Post()
    fileprivate let pagination = 3
    fileprivate var skip = 0
    fileprivate var comments = [Comment]()
    fileprivate var currentCommentsCount = 0
    fileprivate var user = ApplicationState.sharedInstance.currentUser
    
    fileprivate let enterInterestedTitleButton: String = "Entrar da fila"
    fileprivate let exitInterestedTitleButton: String = "Sair da fila"
    fileprivate let recommendedTitleButton: String = "Recomendar"
    fileprivate let interestedListTitleButton: String = "Lista de interessados"
    
    var view: PhotoThingDelegate?
    
    
    func setViewDelegate(view: PhotoThingDelegate) {
        self.view = view
    }
    
    func setPost(post: Post) {
        self.post = post
    }
    
    func getPost() -> Post {
        return self.post!
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
    
    func getCountPhotos(success: Bool){
        if success {
            view?.reload()
        } else {
            post!.getRelationCountInBackgroundBy(key: "photos", completionHandler: { (success, msg, count) in
                if success {
                    self.post!.countPhotos = count!
                    self.view?.reload()
                } else {
                    print ("COUNT PHOTOS REQUEST ERROR")
                }
            })
        }
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
    
    func downloadImagesPost(success:Bool) {
        
        if let relations = getPost().relations {
            for relation in relations where !relation.isDownloadedImage {
                relation.getDataInBackgroundBy(key: "imageFile", completionHandler: { (success, msg, data) in
                    if success {
                        relation.photo = UIImage(data: data!)
                        relation.isDownloadedImage = true
                        self.view?.reload()
                    } else {
                        print ("DOWNLOAD IMAGES ERRO")
                    }
                })
            }
        }
    }
}