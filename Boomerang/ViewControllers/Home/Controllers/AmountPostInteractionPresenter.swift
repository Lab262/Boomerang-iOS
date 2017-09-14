//
//  AmountPostInteractionPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 26/08/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

protocol AmountPostDelegate {
    func showMessage(isSuccess: Bool, msg: String)
    var likeAmount: String? {set get}
    var commentAmount: String? {set get}
    var recommendedAmount: String? {set get}
    var isLikedPost: Bool? {set get}
}

class AmountPostInteractionPresenter: NSObject {
    
    var delegate: AmountPostDelegate?
    var post: Post?
    
    func setViewDelegate(delegate: AmountPostDelegate) {
        self.delegate = delegate
    }
    
    override func awakeFromNib() {
        
    }
    
    func getLikeAmount(isSelectedButton: Bool?) {
        PostRequest.getLikeCount(by: post!) { (success, msg, amount) in
            
            if success {
                
                self.delegate?.likeAmount = String(amount!)
                
                if let isSelectedButton = isSelectedButton {
                    self.delegate?.isLikedPost = isSelectedButton
                }
                
            } else {
                
            }
        }
    }
    
    func getCommentAmount() {
        CommentRequest.getCommentsCount(by: post!) { (success, msg, amount) in
            
            if success {
                self.delegate?.commentAmount = String(amount!)
            } else {
                
            }
        }
    }
    
    func getRecommendationAmount() {
        PostRequest.getRecommendationCount(by: post!) { (success, msg, amount) in
            
            if success {
                self.delegate?.recommendedAmount = String(amount!)
            } else {
                
            }
        }
    }
    
    func verifyIsLiked() {
        PostRequest.verifyAlreadyLiked(currentProfile: User.current()!.profile!, post: post!) { (success, msg, isLiked) in
            
            if success {
                self.delegate?.isLikedPost = isLiked
            } else {
                
            }
            
        }
    }
    
    func likedPost() {
        if let post = post {
            PostRequest.likePost(post: post, completionHandler: { (success, msg) in
                if success {
                    self.getLikeAmount(isSelectedButton: true)
                } else {
                    
                }
            })
        }
    }
    
    func unlikePost() {
        if let post = post {
            PostRequest.unlikePost(profile: User.current()!.profile!, post: post, completionHandler: { (success, msg) in
                if success {
                    self.getLikeAmount(isSelectedButton: false)
                } else {
                    
                }
            })
        }
    }
}
