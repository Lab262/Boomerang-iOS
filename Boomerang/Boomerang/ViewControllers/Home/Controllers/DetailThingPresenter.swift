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
    
    fileprivate var post:Post? = nil
    fileprivate let pagination = 3
    fileprivate var skip = 0
    fileprivate var comments = [Comment]()
    var controller: ViewControllerDelegate?
    
    
    func setControllerDelegate(controller: ViewControllerDelegate) {
        self.controller = controller
    }
    
    func updateComments() {
        self.skip = self.comments.endIndex

        CommentRequest.fetchCommentsBy(post: self.post!, pagination: pagination, skip: self.skip) { (success, msg, comments) in
            if success {
                for comment in comments! {
                    self.comments.append(comment)
                }
                self.controller?.updateView(array: self.comments)
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
    
}
