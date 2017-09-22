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
    func didSearch(scope: TypePostEnum, searchString: String)
}

class SearchThingsPresenter: NSObject {
    
    var posts: [Post] = [Post]()
    var people: [Profile] = [Profile]()
    var profile: Profile = User.current()!.profile!
    var view: SearchThingsResultDelegate?
    var currentScope = TypePostEnum.atIndex(0)
    var currentSearchString = ""

    func setViewDelegate(view: SearchThingsResultDelegate) {
        self.view = view
    }
    
    func searchPost(in scope: TypePostEnum, with searchString: String) {
        self.currentScope = scope
        self.currentSearchString = searchString
        self.view?.startFooterLoading()
        PostRequest.searchPosts(type: scope, searchString: searchString, postsDownloaded: [Post](), pagination: Paginations.morePosts) { (success, msg, posts) in
            if success {
                self.posts = [Post]()
                posts!.forEach {
                    self.posts.append($0)
                }
                self.view?.reload()
            } else {
                self.view?.showMessage(isSuccess: false, msg: msg)
            }

            self.view?.finishFooterLoading()
        }
    }

    func getMorePosts() {
        self.view?.startFooterLoading()
        PostRequest.searchPosts(type: self.currentScope, searchString: self.currentSearchString, postsDownloaded: self.posts, pagination: Paginations.morePosts) { (success, msg, posts) in
            if success {
                posts!.forEach {
                    self.posts.append($0)
                }
                self.view?.reload()
            } else {
                self.view?.showMessage(isSuccess: false, msg: msg)
            }

            self.view?.finishFooterLoading()
        }
    }


}
