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
    
    fileprivate let pagination = 50
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
        return messages
    }
    
    func convertMessageForJSQMessage(message: Message) {
        let message = JSQMessage(senderId: message.user?.objectId, senderDisplayName: "", date: message.createdDate!, text: message.message!)
        messages.append(message!)
    }
    
    private func setMessage(message: Message) {
        let jsqMessage = JSQMessage(senderId: message.user!.objectId, senderDisplayName: "", date: Date(), text: message.message)
        self.messages.append(jsqMessage!)
    }
    
    func requestMessagesOfChat() {
        skip = chat.messagesArray.endIndex
        
        ChatRequest.getMessagesInBackground(chat: chat, skip: skip, pagination: pagination) { (success, msg, msgs) in
            if success {
                for newMessage in msgs! {
                    self.setMessage(message: newMessage)
                }
                self.view?.reload()
            } else {
                self.view?.showMessage(msg: msg)
            }
        }
    }
    
    private func createMessage(senderId: String, text: String) -> Message {
        let userMessage: Profile = senderId == chat.owner!.objectId! ? chat.owner! : chat.requester!
        let message = Message(message: text, user: userMessage)
        setMessage(message: message)
        return message
    }
    
    func sendMessage(senderId: String, text: String) {
        let message = createMessage(senderId: senderId, text: text)
        ChatRequest.createMessageInChat(message: message, chat: chat) { (success, msg) in
            if success {
                self.view?.updateStatusMessage(success: success)
            } else {
                print ("ERROR IN CREATION MESSAGE")
            }
        }
    }
}
