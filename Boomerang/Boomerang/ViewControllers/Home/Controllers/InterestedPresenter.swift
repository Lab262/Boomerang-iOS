//
//  InterestedPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 01/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class InterestedPresenter: NSObject {
    
    fileprivate var interesteds: [Interested] = [Interested]()
    fileprivate var currentInterested: Interested = Interested()
    fileprivate var post: Post = Post()
    fileprivate let pagination = 3
    fileprivate var skip = 0
    fileprivate var controller: ViewDelegate?
    fileprivate var currentInterestedsCount = 0
    
    
    
    func setControllerDelegate(controller: ViewDelegate) {
        self.controller = controller
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
    
    func setPost(post: Post) {
        self.post = post
    }
    
    func getPost() -> Post {
        return post
    }
    
    func updateInteresteds(){
        self.skip = interesteds.endIndex
        
        PostRequest.fetchInterestedOf(post: getPost(), selectKeys: ["user", "currentMessage"], pagination: pagination, skip: skip) { (success, msg, interesteds) in
            
            if success {
                for interested in interesteds! {
                    self.interesteds.append(interested)
                }
                
                self.controller?.reload()
                self.currentInterestedsCount = self.getInteresteds().count
            } else {
                self.controller?.showMessageError(msg: msg)
            }
        }
    }
    
    func startScheme(){
        
    }
    
    func getUserPhotoImage(completionHandler: @escaping (_ success: Bool, _ msg: String, _ image: UIImage?) -> Void){
        guard let image = getInterested().user?.profileImage else {
            getInterested().user?.getDataInBackgroundBy(key: #keyPath(User.imageFile), completionHandler: { (success, msg, data) in
                
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
