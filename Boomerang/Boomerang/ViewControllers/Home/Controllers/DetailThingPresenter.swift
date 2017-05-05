//
//  DetailThingPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 28/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse


protocol DetailThingDelegate {
    func reload()
    var commentCount: Int? {set get}
    func showMessage(isSuccess: Bool, msg: String)
    var interestedTitleButton: String? {set get}
}


class DetailThingPresenter: NSObject {
    
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
    
    var view: DetailThingDelegate?
    
    func setViewDelegate(view: DetailThingDelegate) {
        self.view = view
    }
    
    func getEnterInterestedTitleButton() -> String {
        return enterInterestedTitleButton
    }
    
    func getExitInterestedTitleButton() -> String {
        return exitInterestedTitleButton
    }
    
    func getRecommendedTitleButton() -> String {
        return recommendedTitleButton
    }
    
    func getInterestedListTitleButton() -> String {
        return interestedListTitleButton
    }
    
    func getComments() -> [Comment] {
        return comments
    }
    
    func setPost(post: Post) {
        self.post = post
    }
    
    func getPost() -> Post {
        return self.post!
    }
    
    func getUser() -> User {
        return user!
    }
    
    func getAuthorOfPost() -> Profile {
        return post!.author!
    }
    
    func getCurrentCommentsCount() -> Int {
        return currentCommentsCount
    }
    
    func getCurrentType() -> String {
        switch self.getPost().postType! {
        case .have:
            return "Tenho"
        case .need:
            return "Preciso"
        case .donate:
            return "Doação"
        }
    }
    
    func authorPostIsCurrent() -> Bool {
        if getPost().author?.objectId == self.user?.profile?.objectId {
            return true
        } else {
            return false
        }
    }
    
 
    
    func getLastsComments(isUpdate: Bool = false) {
        CommentRequest.fetchCommentsBy(post: self.post!, commentsObject: self.comments, pagination: pagination) { (success, msg, comments) in
            if success {
                for comment in comments! {
                    if isUpdate {
                        self.comments.insert(comment, at: 0)
                    } else {
                        self.comments.append(comment)
                    }
                }
                self.view?.reload()
                self.currentCommentsCount = self.getComments().count
                
            } else {
                self.view?.showMessage(isSuccess: false, msg: msg)
            }
        }
    }
    
    func getCommentCounts() {
        CommentRequest.getCommentsCount(by: self.post!) { (success, msg, count) in
            if success {
                self.view?.commentCount = count
            } else {
                self.view?.showMessage(isSuccess: false, msg: msg)
            }
        }
    }
    
    func saveComment(comment: Comment) {
        comment.saveObjectInBackground { (success, msg) in
            if success {
                self.skip = self.comments.endIndex
                self.getLastsComments(isUpdate: true)
            } else {
                self.view?.showMessage(isSuccess: false, msg: msg)
            }
        }
    }
    
    func createInterestedChat(completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        let chat = Chat(post: getPost(), requester: getUser().profile!, owner: getAuthorOfPost())
        chat.saveObjectInBackground { (success, msg) in
             completionHandler(success, msg)
        }
    }
    
    func enterInterestedList() {
        let interested = Interested(user: getUser().profile, post: getPost(), currentMessage: "Estou interessado, fico feliz em ajudar")
        interested.saveObjectInBackground { (success, msg) in
            if success {
                self.createInterestedChat(completionHandler: { (success, msg) in
                    if success {
                        self.view?.interestedTitleButton = self.exitInterestedTitleButton
                        self.view?.showMessage(isSuccess: success, msg: "Você está dentro da lista de interessados. Agora é só aguardar.")
                    } else {
                        self.view?.showMessage(isSuccess: success, msg: msg)
                    }
                })
            } else {
                self.view?.showMessage(isSuccess: success, msg: msg)
            }
        }
    }

    func exitInterestedList() {
        PostRequest.exitInterestedListOf(user: user!, post: post!) { (success, msg) in
            if success {
                self.view?.interestedTitleButton = self.enterInterestedTitleButton
                self.view?.showMessage(isSuccess: success, msg: "Você saiu da lista de interessados.")
            } else {
                self.view?.showMessage(isSuccess: false, msg: msg)
            }
        }
    }
    
    func alreadyInterested(){
        PostRequest.verifyAlreadyInterestedFor(currentProfile: user!.profile!, post: post!) { (success, msg, alreadyInterested) in
            
            if success {
                self.view?.interestedTitleButton = alreadyInterested ? self.exitInterestedTitleButton : self.enterInterestedTitleButton
            } else {
                self.view?.showMessage(isSuccess: false, msg: msg)
            }
        }
    }
    
    func createComment(text: String) {
        let comment = Comment(post: self.post!, content: text, author: (self.user?.profile)!)
        
        saveComment(comment: comment)
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
    
    func getUserPhotoImage(completionHandler: @escaping (_ success: Bool, _ msg: String, _ image: UIImage?) -> ()){
        
        guard let image = getPost().author?.profileImage else {
            getPost().author?.getDataInBackgroundBy(key: #keyPath(User.photo), completionHandler: { (success, msg, data) in
                
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
