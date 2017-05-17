//
//  PostPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 17/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class PostPresenter: NSObject {
    
    var post: Post = Post()
    var posts: [Post] = [Post]()
    var view: ViewDelegate?
    var user: User = ApplicationState.sharedInstance.currentUser!
    
    
    func setViewDelegate(view: ViewDelegate) {
        self.view = view
    }
    
    func getCountPhotos(){
        if post.countPhotos < 1 {
            post.getRelationCountInBackgroundBy(key: "photos", completionHandler: { (success, msg, count) in
                if success {
                    self.post.countPhotos = count!
                    ApplicationState.sharedInstance.callDelegateUpdate(post: self.post, success: true, updateType: .amount)
                } else {
                    ApplicationState.sharedInstance.callDelegateUpdate(post: nil, success: true, updateType: .amount)
                }
            })
        }
    }
    
    func getCoverOfPost(completionHandler: @escaping (_ success: Bool, _ msg: String, _ image: UIImage?) -> Void){
        PostRequest.getRelationsInBackground(post: post) { (success, msg) in
            if success {
                self.downloadCoverImagePost(completionHandler: { (success, msg, image) in
                    completionHandler(success, msg, image)
                })
            } else {
                completionHandler(false, msg, nil)
            }
        }
    }
    
    func downloadCoverImagePost(completionHandler: @escaping (_ success: Bool, _ msg: String, _ image: UIImage?) -> Void){
        if let relations = post.relations {
            guard let cover = relations.first?.photo else {
                relations.first?.getDataInBackgroundBy(key: "imageFile", completionHandler: { (success, msg, data) in
                    
                    if success {
                        relations.first?.photo = UIImage(data: data!)
                        relations.first?.isDownloadedImage = true
                        completionHandler(success, msg, relations.first?.photo)
                    } else {
                        completionHandler(success, msg, nil)
                    }
                })
                return
            }
            
            completionHandler(true, "success", cover)
        }
    }
    
    func getIconPost(iconImage: UIImageView, height: NSLayoutConstraint, width: NSLayoutConstraint) {
        if post.typePost == .have {
            iconImage.image = #imageLiteral(resourceName: "have-icon")
            height.constant = 25.0
            width.constant = 35.0
        } else if post.typePost == .need {
            iconImage.image = #imageLiteral(resourceName: "need_icon")
            height.constant = 25.0
            width.constant = 17.0
        } else {
            iconImage.image = #imageLiteral(resourceName: "donate_icon")
            height.constant = 24.0
            width.constant = 27.0
        }
        iconImage.layoutIfNeeded()
    }
    
}
