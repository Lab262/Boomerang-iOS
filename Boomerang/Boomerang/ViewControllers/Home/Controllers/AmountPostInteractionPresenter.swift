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
}

class AmountPostInteractionPresenter: NSObject {
    
    var delegate: AmountPostDelegate?
    var post: Post?
    
    func setViewDelegate(delegate: AmountPostDelegate) {
        self.delegate = delegate
    }
    
    func likedPost() {
        if let post = post {
            PostRequest.likePost(post: post, completionHandler: { (success, msg) in
                
                if success {
                    
                } else {
                    
                }
            })
        }
    }
}
