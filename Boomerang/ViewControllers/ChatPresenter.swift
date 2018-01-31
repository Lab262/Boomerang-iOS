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
    var profile: Profile = User.current()!.profile!
    var messages = [JSQMessage]()
    
    fileprivate let liveQueryClient = ApplicationState.sharedInstance.liveQueryClient
    fileprivate var subscriptionChatUpdated: Subscription<Chat>?
    fileprivate var subscriptionMessageCreated: Subscription<Message>?
    
    
    func setViewDelegate(view: ChatDelegate) {
        self.view = view
    }
    
    func convertMessageForJSQMessage(message: Message) {
        let message = JSQMessage(senderId: message.sender?.objectId, senderDisplayName: "", date: message.createdAt!, text: message.message!)
        messages.append(message!)
    }
    
    fileprivate func setMessage(message: Message) {
        let jsqMessage = JSQMessage(senderId: message.sender!.objectId, senderDisplayName: "", date: Date(), text: message.message)
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
       
        var message: Message?
        
        if senderId == chat.owner!.objectId! {
            message = Message(message: text, sender: chat.owner!, receiver: chat.requester!, chatId: chat.objectId!)
        } else {
            message = Message(message: text, sender: chat.requester!, receiver: chat.owner!, chatId: chat.objectId!)
        }
        setMessage(message: message!)
        return message!
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
                
               if message.sender?.objectId != self.profile.objectId {
                    DispatchQueue.main.sync {
                        self.setMessage(message: message)
                        self.view?.reload()
                    }
                }
                //self.requestMessagesOfChat()
        }
    }
    
}



