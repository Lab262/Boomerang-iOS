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
    func startFooterLoading()
    func finishFooterLoading()
    func startLoading()
    func finishLoading()
}


class DetailThingPresenter: NSObject {
    
    var post: Post = Post()
    var comments = [Comment]()
    var currentCommentsCount = 0
    var profile = User.current()!.profile
    let enterInterestedTitleButton: String = TitleButtons.enterInterested
    let exitInterestedTitleButton: String = TitleButtons.exitInterested
    let recommendedTitleButton: String = TitleButtons.recommended
    let interestedListTitleButton: String = TitleButtons.interestedList
    var view: DetailThingDelegate?
    var commentCount = 0
    let liveQueryClient = ApplicationState.sharedInstance.liveQueryClient
    var subscriptionComment: Subscription<Comment>?
    var subscriptionCreateLike: Subscription<Like>?
    var subscriptionUpdateLike: Subscription<Like>?
    
    func setViewDelegate(view: DetailThingDelegate) {
        self.view = view
    }
    func getAuthorOfPost() -> Profile {
        return post.author!
    }
    
    func getCurrentType() -> String {
        switch post.typePostEnum! {
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
         self.view?.startFooterLoading()
        CommentRequest.fetchLastCommentsBy(post: self.post, commentsObject: self.comments, pagination: Paginations.comments) { (success, msg, comments) in
            if success {
                for comment in comments! {
                   self.comments.insert(comment, at: 0)
                }
                self.view?.reload()
                self.view?.finishFooterLoading()
                //self.currentCommentsCount = self.comments.count
            } else {
                self.view?.showMessage(isSuccess: false, msg: msg)
                self.view?.finishFooterLoading()
            }
        }
    }
    
    func getLastsComments(isUpdate: Bool = false) {
        self.view?.startFooterLoading()
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
                
                self.view?.finishFooterLoading()
              
                self.view?.reload()
                //self.currentCommentsCount = self.comments.count
            } else {
                self.view?.finishFooterLoading()
                self.view?.showMessage(isSuccess: false, msg: msg)
            }
        }
    }
    
    func getCommentCounts() {
        CommentRequest.getCommentsCount(by: self.post) { (success, msg, count) in
            if success {
                self.commentCount = count!
                self.view?.commentCount = count
                self.getLastsComments()
            } else {
                self.view?.showMessage(isSuccess: false, msg: msg)
            }
        }
    }
    
    func saveComment(comment: Comment) {
        comment.saveObjectInBackground { (success, msg) in
            if success {
                //self.getLastsComments(isUpdate: true)
                //self.getLastComments()
            } else {
                self.view?.showMessage(isSuccess: false, msg: msg)
            }
        }
    }
    
    func createSchemeInProgress(chat: Chat, completionHandler: @escaping (_ success: Bool, _ msg: String) -> ()) {
        let scheme = Scheme(post: post, requester: profile!, owner: getAuthorOfPost(), chat: chat)
        scheme.saveObjectInBackground { (success, msg) in
            if success {
                SchemeRequest.updateChatScheme(scheme: scheme, chat: chat, completionHandler: { (success, msg) in
                    completionHandler(success, msg)
                })
            } else {
                completionHandler(success, msg)
            }
        }
    }
    
    func createInterestedChat(completionHandler: @escaping (_ success: Bool, _ msg: String, _ chat: Chat) -> ()) {
        let chat = Chat(post: post, requester: profile!, owner: getAuthorOfPost())
        chat.saveObjectInBackground { (success, msg) in
             completionHandler(success, msg, chat)
        }
    }
    
    func enterInterestedList(completionHandler: @escaping (_ success: Bool, _ msg: String, _ title: String) -> ()) {
        self.view?.startLoading()
        let interested = Interested(user: profile!, post: post, currentMessage: "Estou interessado tesste")
        
        interested.saveInBackground { (success, error) in
            if success {
                self.view?.interestedTitleButton = self.exitInterestedTitleButton
                completionHandler(success, "", self.view!.interestedTitleButton!)
                self.view?.showMessage(isSuccess: success, msg: NotificationSuccessMessages.enterInterestedList)
                self.view?.finishLoading()
            } else {
                self.view?.showMessage(isSuccess: success, msg: error!.localizedDescription
                )
                completionHandler(success, "", "")
                
                self.view?.finishLoading()
            }
        }
    }

    func exitInterestedList(completionHandler: @escaping (_ success: Bool, _ msg: String, _ title: String) -> ()) {
        self.view?.startLoading()
        PostRequest.exitInterestedListOf(profile: profile!, post: post) { (success, msg) in
            if success {
                self.view?.interestedTitleButton = self.enterInterestedTitleButton
                self.view?.showMessage(isSuccess: success, msg: NotificationSuccessMessages.exitInterestedList)
                completionHandler(success, "", self.view!.interestedTitleButton!)
                self.view?.finishLoading()
            } else {
                self.view?.showMessage(isSuccess: false, msg: msg)
                completionHandler(success, "", "")
                self.view?.finishLoading()
            }
        }
    }
    
    func alreadyInterested(completionHandler: @escaping (_ success: Bool, _ msg: String, _ title: String) -> ()) {
        PostRequest.verifyAlreadyInterestedFor(currentProfile: profile!, post: post) { (success, msg, alreadyInterested) in
            
            if success {
                self.view?.interestedTitleButton = alreadyInterested ? self.exitInterestedTitleButton : self.enterInterestedTitleButton
                completionHandler(success, msg, (self.view?.interestedTitleButton)!)
            } else {
                self.view?.showMessage(isSuccess: false, msg: msg)
                completionHandler(success, msg, "")
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
    
    func getCountPhotos(success: Bool) {
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
    
    func getAverageStars (completionHandler: @escaping (_ success: Bool, _ msg: String, _ averageStars: Int?) -> ()){
        
        ProfileRequest.getAverageStars(profile: post.author!) { (success, msg, averageStars) in
            completionHandler(success, msg, averageStars)
        }
    }
}


//MARK - Live Querys

extension DetailThingPresenter {
    
    var commentQuery: PFQuery<Comment>? {
        return (Comment.query()?
            .whereKey("post", equalTo: post).includeKey("author")
            .order(byAscending: "createdAt")as! PFQuery<Comment>)
    }
    
    var likeQuery: PFQuery<Like>? {
        return (Like.query()?.whereKey("post", equalTo: post) as! PFQuery<Like>)
    }
    
    func subscribeToUpdateComment() {
        subscriptionComment = liveQueryClient
            .subscribe(commentQuery!)
            .handle(Event.created) { _, comment in
                self.printMessage(comment: comment)
        }
    }
    
    func subscribeToUpdateLike() {
//        subscriptionCreateLike = liveQueryClient
//            .subscribe(likeQuery!)
//            .handle(Event.created) { _, like in
//                self.view?.reload()
//        }
//        
//        subscriptionUpdateLike = liveQueryClient
//            .subscribe(likeQuery!)
//            .handle(Event.updated) { _, like in
//                self.view?.reload()
//        }
    }
    
    
    func printMessage(comment: Comment) {
        self.getLastComments()
    }
}
