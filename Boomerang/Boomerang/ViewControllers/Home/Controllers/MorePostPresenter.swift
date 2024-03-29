//
//  MorePostPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 18/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit


class MorePostPresenter: NSObject {
    
    var posts: [Post] = [Post]()
    var friends: [Profile] = [Profile]()
    var profile: Profile = ApplicationState.sharedInstance.currentUser!.profile!
    var view: ViewDelegate?
    var sectionPost: SectionPost?
    
    func setViewDelegate(view: ViewDelegate) {
        self.view = view
    }

    func getMorePosts() {
        PostRequest.getPostsThatNotContain(friends: friends, postsDownloaded: posts, pagination: Paginations.morePosts) { (success, msg, posts) in
            if success {
                posts!.forEach {
                    self.posts.append($0)
                }
                self.view?.reload()
            } else {
                self.view?.showMessageError(msg: msg)
            }
        }
    }
}
