//
//  ChatPresenter.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 25/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import ParseLiveQuery
import JSQMessagesViewController

protocol ChatDelegate {
    func reload()
    func showMessage(msg: String)
    func updateStatusMessage(success: Bool)
}

class ChatPresenter: NSObject {
    
    fileprivate let pagination = Paginations.messages
    var chat: Chat = Chat()
    fileprivate var view: ChatDelegate?
    var profile: Profile = ApplicationState.sharedInstance.currentUser!.profile!
    var messages = [JSQMessage]()
    
    fileprivate let liveQueryClient = ApplicationState.sharedInstance.liveQueryClient
    fileprivate var subscriptionChatUpdated: Subscription<Chat>?
    fileprivate var subscriptionMessageCreated: Subscription<Message>?
    
    
    func setViewDelegate(view: ChatDelegate) {
        self.view = view
    }
    
    func convertMessageForJSQMessage(message: Message) {
        let message = JSQMessage(senderId: message.user?.objectId, senderDisplayName: "", date: message.createdAt!, text: message.message!)
        messages.append(message!)
    }
    
    fileprivate func setMessage(message: Message) {
        let jsqMessage = JSQMessage(senderId: message.user!.objectId, senderDisplayName: "", date: Date(), text: message.message)
        self.messages.append(jsqMessage!)
    }
    
    func requestMessagesOfChat() {
        ChatRequest.getMessagesInBackground(chat: chat, pagination: pagination) { (success, msg, msgs) in
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
        let message = Message(message: text, user: userMessage, chatId: chat.objectId!)
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

extension ChatPresenter {
    
    fileprivate var chatQuery: PFQuery<Chat>? {
        return (Chat.query()?
            .whereKey(ObjectKeys.objectId, equalTo: chat.objectId!)
            .order(byAscending: ObjectKeys.updatedAt) as! PFQuery<Chat>)
    }
    
    fileprivate var messageQuery: PFQuery<Message>? {
        return (Message.query()?
            .whereKey(MessageKeys.chatId, equalTo: chat.objectId!)
            .order(byAscending: ObjectKeys.createdAt) as! PFQuery<Message>)
    }
    
    func setupSubscriptions() {
       // subscriptionToChatQuery()
        subscriptionToMessageQuery()
    }
    
    func subscriptionToMessageQuery() {
        subscriptionMessageCreated = liveQueryClient
            .subscribe(messageQuery!)
            .handle(Event.created) { _, message in
                
               if message.user?.objectId != self.profile.objectId {
                    self.setMessage(message: message)
                    self.view?.reload()
                }
                //self.requestMessagesOfChat()
        }
    }
    
}



