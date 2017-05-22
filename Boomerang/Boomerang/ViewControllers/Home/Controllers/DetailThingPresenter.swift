//
//  DetailThingPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 28/03/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery


protocol DetailThingDelegate {
    func reload()
    var commentCount: Int? {set get}
    func showMessage(isSuccess: Bool, msg: String)
    var interestedTitleButton: String? {set get}
}


class DetailThingPresenter: NSObject {
    
    var post: Post = Post()
    var comments = [Comment]()
    var currentCommentsCount = 0
    var profile = ApplicationState.sharedInstance.currentUser!.profile
    let enterInterestedTitleButton: String = TitleButtons.enterInterested
    let exitInterestedTitleButton: String = TitleButtons.exitInterested
    let recommendedTitleButton: String = TitleButtons.recommended
    let interestedListTitleButton: String = TitleButtons.interestedList
    var view: DetailThingDelegate?
    var commentCount = 0
    let liveQueryClient = ApplicationState.sharedInstance.liveQueryClient
    var subscription: Subscription<Comment>?
    
    func setViewDelegate(view: DetailThingDelegate) {
        self.view = view
    }
    func getAuthorOfPost() -> Profile {
        return post.author!
    }
    
    func getCurrentType() -> String {
        switch post.typePost! {
        case .have:
            return TypePostTitles.have
        case .need:
            return TypePostTitles.need
        case .donate:
            return TypePostTitles.donate
        }
    }
    
    func authorPostIsCurrent() -> Bool {
        if post.author?.objectId == profile?.objectId {
            return true
        } else {
            return false
        }
    }
    
    func getLastComments() {
        CommentRequest.fetchLastCommentsBy(post: self.post, commentsObject: self.comments, pagination: Paginations.comments) { (success, msg, comments) in
            if success {
                for comment in comments! {
                   self.comments.insert(comment, at: 0)
                }
                self.view?.reload()
                self.currentCommentsCount = self.comments.count
            } else {
                self.view?.showMessage(isSuccess: false, msg: msg)
            }
        }
    }
    
    func getLastsComments(isUpdate: Bool = false) {
        CommentRequest.fetchCommentsBy(post: self.post, commentsObject: self.comments, pagination: Paginations.comments) { (success, msg, comments) in
            if success {
                self.commentCount = self.commentCount - comments!.count
                for comment in comments! {
                    if isUpdate {
                        self.comments.insert(comment, at: 0)
                    } else {
                        self.comments.append(comment)
                    }
                }
                self.view?.reload()
                self.currentCommentsCount = self.comments.count
            } else {
                self.view?.showMessage(isSuccess: false, msg: msg)
            }
        }
    }
    
    func getCommentCounts() {
        CommentRequest.getCommentsCount(by: self.post) { (success, msg, count) in
            if success {
                self.commentCount = count!
                self.view?.commentCount = count
            } else {
                self.view?.showMessage(isSuccess: false, msg: msg)
            }
        }
    }
    
    func saveComment(comment: Comment) {
        comment.saveObjectInBackground { (success, msg) in
            if success {
                //self.getLastsComments(isUpdate: true)
                self.getLastComments()
            } else {
                self.view?.showMessage(isSuccess: false, msg: msg)
            }
        }
    }
    
    func createSchemeInProgress(chat: Chat, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        let scheme = Scheme(post: post, requester: profile!, owner: getAuthorOfPost(), chat: chat)
        scheme.saveObjectInBackground { (success, msg) in
             completionHandler(success, msg)
        }
    }
    
    func createInterestedChat(completionHandler: @escaping (_ success: Bool, _ msg: String, _ chat: Chat) -> ()) {
        let chat = Chat(post: post, requester: profile!, owner: getAuthorOfPost())
        chat.saveObjectInBackground { (success, msg) in
             completionHandler(success, msg, chat)
        }
    }
    
    func enterInterestedList() {
        
        let interested = Interested(user: profile, post: post, currentMessage: "Estou interessado, fico feliz em ajudar")
        
        interested.saveObjectInBackground { (success, msg) in
            if success {
                self.createInterestedChat(completionHandler: { (success, msg, chat) in
                    if success {
                        self.createSchemeInProgress(chat: chat, completionHandler: { (success, msg) in
                            if success {
                                self.view?.interestedTitleButton = self.exitInterestedTitleButton
                                self.view?.showMessage(isSuccess: success, msg: NotificationSuccessMessages.enterInterestedList)
                            } else {
                                self.view?.showMessage(isSuccess: success, msg: msg)
                            }
                        })
                       
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
        PostRequest.exitInterestedListOf(profile: profile!, post: post) { (success, msg) in
            if success {
                self.view?.interestedTitleButton = self.enterInterestedTitleButton
                self.view?.showMessage(isSuccess: success, msg: NotificationSuccessMessages.exitInterestedList)
            } else {
                self.view?.showMessage(isSuccess: false, msg: msg)
            }
        }
    }
    
    func alreadyInterested(){
        PostRequest.verifyAlreadyInterestedFor(currentProfile: profile!, post: post) { (success, msg, alreadyInterested) in
            
            if success {
                self.view?.interestedTitleButton = alreadyInterested ? self.exitInterestedTitleButton : self.enterInterestedTitleButton
            } else {
                self.view?.showMessage(isSuccess: false, msg: msg)
            }
        }
    }
    
    func createComment(text: String) {
        let comment = Comment(post: self.post, content: text, author: profile!)
        
        saveComment(comment: comment)
    }
    

    
    func getRelationsImages(success: Bool){
        if !success {
            PostRequest.getRelationsInBackground(post: post, completionHandler: { (success, msg) in
                if success {
                    self.downloadImagesPost(success: true)
                } else {
                    print ("RELATIONS REQUEST ERROR")
                }
            })
        }
    }
    
    func downloadImagesPost(success:Bool) {
        if let relations = post.relations {
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
        if let relations = post.relations {
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
            post.getRelationCountInBackgroundBy(key: "photos", completionHandler: { (success, msg, count) in
                if success {
                    self.post.countPhotos = count!
                    self.view?.reload()
                } else {
                    print ("COUNT PHOTOS REQUEST ERROR")
                }
            })
        }
    }
}


//MARK - Live Querys

extension DetailThingPresenter {
    
    var commentQuery: PFQuery<Comment>? {
        return (Comment.query()?
            .whereKey("post", equalTo: post)
            .order(byAscending: "createdAt") as! PFQuery<Comment>)
    }
    
    func subscribeToUpdateComment() {
        subscription = liveQueryClient
            .subscribe(commentQuery!)
            .handle(Event.created) { _, comment in
                self.printMessage(comment: comment)
        }
    }
    
    func printMessage(comment: Comment) {
        
    }
}
