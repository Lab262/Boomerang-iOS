//
//  DetailThingPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 28/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class DetailThingPresenter: NSObject {
    
    fileprivate var post:Post? = Post()
    fileprivate let pagination = 3
    fileprivate var skip = 0
    fileprivate var comments = [Comment]()
    var controller: ViewDelegate?
    
    
    func setControllerDelegate(controller: ViewDelegate) {
        self.controller = controller
    }
    
    func updateComments() {
        self.skip = self.comments.endIndex

        CommentRequest.fetchCommentsBy(post: self.post!, pagination: pagination, skip: self.skip) { (success, msg, comments) in
            if success {
                for comment in comments! {
                    self.comments.append(comment)
                }
                self.controller?.reload(array: self.comments)
            } else {
                self.controller?.showMessageError(msg: msg)
            }
        }
    }
    
    func getComments() -> [Comment] {
        return comments
    }
    
    func setPost(post: Post) {
        self.post = post
    }
    
    func getPost() -> Post {
        return post!
    }
    
    func saveComment(comment: Comment) {
        
        CommentRequest.saveComment(comment: comment) { (success, msg) in
            if success {
                self.skip = self.comments.endIndex
                self.updateComments()
            } else {
                self.controller?.showMessageError(msg: msg)
            }
        }
    }
    
    func createComment(text: String) {
        
        let comment = Comment(post: self.post!, content: text, author: PFUser.current()! as! User)
        
        saveComment(comment: comment)
    }
    
//    
//    func getRelationPhotosByThing(){
//        if let relations = post.relations {
//            for relation in relations where relation.isDownloadedImage {
//                postImage.image = relation.photo
//                return
//            }
//        } else {
//            PostRequest.getRelationsInBackground(post: post, completionHandler: { (success, msg) in
//                if success {
//                    self.post.relations!.first!.getDataInBackgroundBy(key: "imageFile", completionHandler: { (success, msg, data) in
//                        if success {
//                            self.post.relations!.first!.photo = UIImage(data: data!)
//                            self.post.relations!.first!.isDownloadedImage = true
//                            self.postImage.image = UIImage(data: data!)
//                            ApplicationState.sharedInstance.callDelegateUpdate(post: self.post, success: true, updateType: .download)
//                        } else {
//                            ApplicationState.sharedInstance.callDelegateUpdate(post: self.post, success: false, updateType: .download)
//                            print ("NO SUCCESS IN DOWNLOAD")
//                        }
//                    })
//                } else {
//                    ApplicationState.sharedInstance.callDelegateUpdate(post: nil, success: false, updateType: .relation)
//                    print ("NO SUCCESS IN DOWNLOAD")
//                }
//            })
//        }
//    }
    
    
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
                        self.controller?.reload(array: nil)
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
    
    func getCountPhotos(success: Bool){
        if success {
            controller?.reload(array: nil)
        } else {
            post!.getRelationCountInBackgroundBy(key: "photos", completionHandler: { (success, msg, count) in
                if success {
                    self.post!.countPhotos = count!
                    self.controller?.reload(array: nil)
                } else {
                    print ("COUNT PHOTOS REQUEST ERROR")
                }
            })
        }
    }
    
    func getUserPhotoImage(completionHandler: @escaping (_ success: Bool, _ msg: String, _ image: UIImage?) -> Void){
        
        guard let image = getPost().author?.profileImage else {
            getPost().author?.getDataInBackgroundBy(key: #keyPath(User.imageFile), completionHandler: { (success, msg, data) in
                
                if success {
                    self.getPost().author?.profileImage = UIImage(data: data!)
                    completionHandler(true, msg, self.getPost().author?.profileImage)
                } else {
                    completionHandler(false, msg, nil)
                }
            })
            return
        }
        completionHandler(true, "Success", image)
    }
    
}
