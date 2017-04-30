//
//  ChatPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 25/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import JSQMessagesViewController

protocol ChatDelegate {
    func reload()
    func showMessage(msg: String)
    func updateStatusMessage(success: Bool)
}

class ChatPresenter: NSObject {
    
    fileprivate let pagination = 3
    fileprivate var skip = 0
    fileprivate var chat: Chat = Chat()
    fileprivate var view: ChatDelegate?
    fileprivate var user: User = ApplicationState.sharedInstance.currentUser!
    fileprivate var messages = [JSQMessage]()
    
    func setViewDelegate(view: ChatDelegate) {
        self.view = view
    }
    
    func setChat(chat: Chat) {
        self.chat = chat
    }
    
    func getUser() -> User {
        return self.user
    }
    
    func getMessages() -> [JSQMessage] {
        chat.messages.forEach {
            let message = JSQMessage(senderId: $0.user?.objectId, senderDisplayName: "", date: $0.createdDate!, text: $0.message!)
            messages.append(message!)
        }
        return messages
    }
    
    private func setMessage(message: Message) {
        let jsqMessage = JSQMessage(senderId: message.user!.objectId, senderDisplayName: "", date: Date(), text: message.message)
        self.messages.append(jsqMessage!)
    }
    
    func requestMessagesOfChat() {
        skip = chat.messages.endIndex
        ChatRequest.getMessagesInBackground(chat: chat, skip: skip, pagination: pagination) { (success, msg) in
            if success {
                self.view?.reload()
            } else {
                self.view?.showMessage(msg: msg)
            }
        }
    }
    
    private func createMessage(senderId: String, text: String) -> Message {
        let userMessage: User = senderId == chat.owner!.objectId! ? chat.owner! : chat.requester!
        let message = Message(message: text, user: userMessage)
        setMessage(message: message)
        return message
    }
    
    func sendMessage(senderId: String, text: String) {
        let message = createMessage(senderId: senderId, text: text)
        chat.createRelationInBackground(key: "messages", object: message) { (success, msg) in
            print ("msg: \(msg)")
            self.view?.updateStatusMessage(success: success)
        }
    }
}
