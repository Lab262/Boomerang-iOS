//
//  MorePostPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 18/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit


protocol SearchThingsResultDelegate {
    func reload()
    func showMessage(isSuccess: Bool, msg: String)
    func startFooterLoading()
    func finishFooterLoading()
    func startLoading()
    func finishLoading()
    func didSearch(scope: SearchThingsScope, searchString: String)
}

class SearchThingsPresenter: NSObject {
    
    var posts: [Post] = [Post]()
    var people: [Profile] = [Profile]()
    var profile: Profile = User.current()!.profile!
    var view: SearchThingsResultDelegate?

    func setViewDelegate(view: SearchThingsResultDelegate) {
        self.view = view
    }

    func getMorePosts() {
        self.view?.startFooterLoading()
        PostRequest.getPostsThatNotContain(friends: [], postsDownloaded: posts, pagination: Paginations.morePosts) { (success, msg, posts) in
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
