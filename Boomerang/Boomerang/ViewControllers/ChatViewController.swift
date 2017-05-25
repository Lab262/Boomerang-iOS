//
//  ChatViewController.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 25/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    var presenter: ChatPresenter = ChatPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBubbles()
        setupPresenterDelegate()
        setupDelegateProperties()
        configureCollectionView()
        requestMessages()
        setupSubscriptions()
    }
    
    func requestMessages() {
        presenter.requestMessagesOfChat()
    }
    
    func setupSubscriptions() {
        presenter.setupSubscriptions()
    }
    
    func setupPresenterDelegate() {
        presenter.setViewDelegate(view: self)
    }
    
    func configureCollectionView() {
        collectionView?.collectionViewLayout.incomingAvatarViewSize = .zero
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
        collectionView.collectionViewLayout.messageBubbleFont = UIFont.montserratSemiBold(size: 14)
        inputToolbar.contentView.leftBarButtonItem = nil
        automaticallyScrollsToMostRecentMessage = true
    }
    
    func setupDelegateProperties() {
        self.senderId = presenter.profile.objectId!
        self.senderDisplayName = presenter.profile.fullName
    }
    
    func setupBubbles() {
        incomingBubble = JSQMessagesBubbleImageFactory(bubble: .jsq_bubbleCompactTailless(), capInsets: .zero).incomingMessagesBubbleImage(with: UIColor.friendMessageChatBackgroundColor)
        
        outgoingBubble = JSQMessagesBubbleImageFactory(bubble: .jsq_bubbleCompactTailless(), capInsets: .zero).incomingMessagesBubbleImage(with: UIColor.myMessageChatBackgroundColor)
    }
    
    // MARK: JSQMessagesViewController method overrides
    
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        presenter.sendMessage(senderId: senderId, text: text)
        self.finishSendingMessage(animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return presenter.messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        
        return presenter.messages[indexPath.item].senderId == self.senderId ? outgoingBubble : incomingBubble
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension ChatViewController: ChatDelegate {
    func reload() {
        self.finishSendingMessage(animated: true)
    }
    
    func updateStatusMessage(success: Bool) {
        reload()
    }
    
    func showMessage(msg: String) {
        
    }
}
