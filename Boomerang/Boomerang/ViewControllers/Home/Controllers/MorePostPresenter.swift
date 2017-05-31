//
//  MorePostPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 18/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit


protocol MorePostDelegate {
    func reload()
    func showMessage(isSuccess: Bool, msg: String)
    func startFooterLoading()
    func finishFooterLoading()
    func startLoading()
    func finishLoading()
}

class MorePostPresenter: NSObject {
    
    var posts: [Post] = [Post]()
    var friends: [Profile] = [Profile]()
    var profile: Profile = User.current()!.profile!
    var view: MorePostDelegate?
    var sectionPost: SectionPost?
    
    func setViewDelegate(view: MorePostDelegate) {
        self.view = view
    }

    func getMorePosts() {
        self.view?.startFooterLoading()
        PostRequest.getPostsThatNotContain(friends: friends, postsDownloaded: posts, pagination: Paginations.morePosts) { (success, msg, posts) in
            if success {
                if posts!.count > 0 {
                    posts!.forEach {
                        self.posts.append($0)
                    }
                    self.view?.reload()
                }
              
            } else {
                self.view?.showMessage(isSuccess: false, msg: msg)
            }
            
            self.view?.finishFooterLoading()
        }
    }
}
