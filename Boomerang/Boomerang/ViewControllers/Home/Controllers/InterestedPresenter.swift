//
//  InterestedPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 01/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

protocol InterestedDelegate {
    func showMessage(msg: String)
    func reload()
    func startingLoadingView()
    func finishLoadingView()
    func pushForChatView()
    func presentTo(storyBoard: String, identifier: String)
}
class InterestedPresenter: NSObject {
    
    fileprivate var interesteds: [Interested] = [Interested]()
    fileprivate var currentInterested: Interested = Interested()
    fileprivate var post: Post = Post()
    fileprivate let pagination = 3
    fileprivate var skip = 0
    fileprivate var view: InterestedDelegate?
    fileprivate var currentInterestedsCount = 0
    fileprivate var currentUser: User = ApplicationState.sharedInstance.currentUser!
    fileprivate var chat: Chat = Chat()
    
    func setViewDelegate(view: InterestedDelegate) {
        self.view = view
    }
    
    func setInteresteds(interesteds: [Interested]) {
        self.interesteds = interesteds
    }
    
    func getInteresteds() -> [Interested] {
        return interesteds
    }
    
    func setInterested(interested: Interested) {
        self.currentInterested = interested
    }
    
    func getInterested() -> Interested {
        return currentInterested
    }
    
    func getCurrentInterestedsCount() -> Int {
        return currentInterestedsCount
    }
    
    func getUser() -> User {
        return currentUser
    }
    
    func setPost(post: Post) {
        self.post = post
    }
    
    func getPost() -> Post {
        return post
    }
    
    func setChat(chat: Chat) {
        self.chat = chat
    }
    
    func getChat() -> Chat {
        return chat
    }
    
    func getRequester() -> Profile {
        return getInterested().user!
    }
    
    func updateInteresteds(){
        self.skip = interesteds.endIndex
        self.view?.startingLoadingView()
        PostRequest.fetchInterestedOf(post: getPost(), selectKeys: ["user", "currentMessage"], pagination: pagination, skip: skip) { (success, msg, interesteds) in
            if success {
                for interested in interesteds! {
                    self.interesteds.append(interested)
                }
                self.view?.reload()
                self.currentInterestedsCount = self.getInteresteds().count
                
            } else {
                self.view?.showMessage(msg: msg)
            }
            self.view?.finishLoadingView()
        }
    }
    
    func fetchChat() {
        self.view?.startingLoadingView()
        ChatRequest.getChatOf(requester: getRequester(), owner: getUser().profile!, post: getPost()) { (success, msg, chat) in
            if success {
                self.setChat(chat: chat!)
                self.view?.pushForChatView()
            } else {
                self.view?.showMessage(msg: msg)
            }
            self.view?.finishLoadingView()
        }
    }
    
    func createScheme(){
        self.view?.startingLoadingView()
        SchemeRequest.getSchemeFor(owner: getUser().profile!, requester: getRequester(), post: getPost()) { (success, msg, scheme) in
            if success {
                SchemeRequest.updateScheme(scheme: scheme!, statusScheme: .progress, completionHandler: { (success, msg) in
                    if success {
                        PostRequest.updatePostIsAvailable(isAvailable: false, post: self.post, completionHandler: { (success, msg) in
                            if success {
                                self.view?.presentTo(storyBoard: "Main", identifier: "")
                            } else {
                                self.view?.showMessage(msg: msg)
                            }
                        })
                        print ("UPDATE SUCCESS")
                    } else {
                        print ("UPDATE FAIL")
                    }
                    self.view?.finishLoadingView()
                })
            } else {
                self.view?.showMessage(msg: msg)
            }
            self.view?.finishLoadingView()
        }
    }
    
    func getUserPhotoImage(completionHandler: @escaping (_ success: Bool, _ msg: String, _ image: UIImage?) -> Void){
        guard let image = getInterested().user?.profileImage else {
            getInterested().user?.getDataInBackgroundBy(key: #keyPath(User.photo), completionHandler: { (success, msg, data) in
                if success {
                    self.getInterested().user?.profileImage = UIImage(data: data!)
                    completionHandler(true, msg, self.getInterested().user?.profileImage)
                } else {
                    completionHandler(false, msg, nil)
                }
            })
            return
        }
        completionHandler(true, "Success", image)
    }

}
