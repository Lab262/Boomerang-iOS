//
//  ThrowPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 04/07/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import Parse


protocol ThrowDelegate {
    func showMessage()
    func showFeedbackSuccessPost()
    
}

class ThrowPresenter: NSObject {
    
    var typePost = TypePostEnum.have
    var typeScheme: ConditionEnum?
    var delegate: ThrowDelegate?
    var params:[String:String] = [:]
    var fields:[Int:String] = [:]
    var images = [UIImage]()
    var isAvailable = true
    
    func setViewDelegate(delegate: ThrowDelegate) {
        self.delegate = delegate
    }
    
    func createPost() {
        let post = Post(author: User.current()!.profile!, title: params[CreatePostTitles.keyParseTitle]!, content: params[CreatePostTitles.keyParseContent]!, loanTime: params[CreatePostTitles.keyParseTime], exchangeDescription: params[CreatePostTitles.keyParseExchangeDescription], place: params[CreatePostTitles.keyParsePlace]!, condition: typeScheme, typePost: typePost)
        
        createRelationsOfPost(post: post)
       
        post.saveInBackground { (success, error) in
            if success {
                self.delegate?.showFeedbackSuccessPost()
            } else {
                self.delegate?.showMessage()
            }
        }
    }
    
    private func createRelationsOfPost(post: Post) {
        let photos = createPhotoObjectsByImages()
        let relation = post.relation(forKey: PostKeys.photos)
        photos.forEach {
            relation.add($0)
        }
    }
    
    private func createPhotoObjectsByImages() -> [Photo] {
        let fileObjects = convertImagesForFiles()
        
        var photos = [Photo]()
        
        for file in fileObjects {
            let photoObject: Photo = Photo()
            photoObject.imageFile = file
            do {
                 try photoObject.save()
                 photos.append(photoObject)
            } catch {
                print ("save photo error")
            }
        }
        return photos
    }
    
    private func convertImagesForFiles() -> [PFFile] {
        let dataImages = images.map {
            UIImageJPEGRepresentation($0, 0.2)
        }
        
        let fileObjects = dataImages.map {
            PFFile(data: $0!, contentType: ParseKeys.contentType)
        }
        
        return fileObjects
    }
    
    private func verifyDefaultParams() -> String? {
        
        let msgsError = [CreatePostTitles.msgErrorTitle, CreatePostTitles.msgErrorDescription, CreatePostTitles.msgErrorPlace]
        
        let keysParams = [CreatePostTitles.keyParseTitle, CreatePostTitles.keyParseContent, CreatePostTitles.keyParsePlace]
        
        
        return verifyEmptyOrNil(msgsError: msgsError, keysParams: keysParams)
    }
    
    func verifyNeedAndPostParams() -> String? {
        let msgsError = [CreatePostTitles.msgErrorTime, CreatePostTitles.msgErrorExchangeDescription]
        let keysParams = [CreatePostTitles.keyParseTime, CreatePostTitles.keyParseExchangeDescription]
        
        return verifyEmptyOrNil(msgsError: msgsError, keysParams: keysParams)
    }
    
    func verifyEmptyParams() -> String? {
        
        if images.isEmpty {
            let msgErro = CreatePostTitles.msgErrorImage
            return msgErro
        }
        
        if typePost == .need || typePost == .have {
            
            if typeScheme == nil {
                let msgErro = CreatePostTitles.msgErrorTypeScheme
                return msgErro
            }
            
            let msgErro = verifyDefaultParams()
            
            return msgErro ?? verifyNeedAndPostParams()
            
        } else {
            return verifyDefaultParams()
        }
    }
    
    func verifyEmptyOrNil(msgsError: [String], keysParams: [String]) -> String? {
        
        var msgErro: String?
        
        for (i, key) in keysParams.enumerated() {
            if params[key] == nil || params[key] == "" {
                msgErro = msgsError[i]
                return msgErro
            }
        }
        return msgErro
    }
    
    //MARK: Parse Fields
    func parseFields(){
        switch typePost {
        case .need, .have:
            parseFieldsNeedOrHave()
        case .donate:
            parseFieldsDonate()
        }
    }
    
    func parseFieldsNeedOrHave(){
        params[CreatePostTitles.keyParseTitle] = self.fields[2]
        params[CreatePostTitles.keyParseContent] = self.fields[3]
        params[CreatePostTitles.keyParseTime] = self.fields[4]
        params[CreatePostTitles.keyParseExchangeDescription] = self.fields[5]
        params[CreatePostTitles.keyParsePlace] = self.fields[6]
    }
    
    func parseFieldsDonate(){
        params[CreatePostTitles.keyParseTitle] = self.fields[1]
        params[CreatePostTitles.keyParseContent] = self.fields[2]
        params[CreatePostTitles.keyParsePlace] = self.fields[3]
    }


}
