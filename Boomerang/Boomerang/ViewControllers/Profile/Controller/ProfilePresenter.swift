//
//  ProfilePresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 04/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse

class ProfilePresenter: NSObject {

    fileprivate var user: User = ApplicationState.sharedInstance.currentUser!
    fileprivate let pagination = 3
    fileprivate var skipPosts = 0
    fileprivate var posts: [Post] = [Post]()
    fileprivate var post: Post = Post()
    
    func getUserImage(completionHandler: @escaping (_ success: Bool, _ msg: String, _ image: UIImage?) -> Void) {
        guard let image = user.profileImage else {
            user.getDataInBackgroundBy(key: #keyPath(User.imageFile), completionHandler: { (success, msg, data) in
                if success {
                    completionHandler(true, "Success", UIImage(data: data!)!)
                } else {
                    completionHandler(false, msg, nil)
                }
            })
            return
        }
        completionHandler(true, "Success", image)
    }
    
    func getUser() -> User{
        return user
    }

}
