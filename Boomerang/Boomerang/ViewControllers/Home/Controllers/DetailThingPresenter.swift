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
    fileprivate let comments = [Comment]()
    var controller: ViewControllerDelegate?
    
    
    func setControllerDelegate(controller: ViewControllerDelegate) {
        self.controller = controller
    }
    
    func updateComments() {
        self.skip = self.comments.endIndex

        CommentRequest.fetchCommentsBy(post: self.post!, pagination: pagination, skip: self.skip) { (success, msg, comments) in
            if success {
                self.controller?.updateView(array: comments!)
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
    
    func sendComment(comment: Comment) {
        comment.saveObjectInBackground { (success, msg) in
            if success {
                self.skip = self.comments.endIndex
                self.updateComments()
            } else {
                self.controller?.showMessageError(msg: msg)
            }
        }
    }
    
}