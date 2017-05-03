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
        presenter.requestMessagesOfChat()
    }
    
    func setupPresenterDelegate() {
        presenter.setViewDelegate(view: self)
    }
    
    func configureCollectionView() {
        collectionView?.collectionViewLayout.incomingAvatarViewSize = .zero
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
        collectionView?.collectionViewLayout.springinessEnabled = false
        automaticallyScrollsToMostRecentMessage = false
        collectionView?.reloadData()
        collectionView?.layoutIfNeeded()
    }
    
    func setupDelegateProperties() {
        self.senderId = presenter.getUser().profile?.objectId!
        self.senderDisplayName = presenter.getUser().fullName
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
        return presenter.getMessages().count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return presenter.getMessages()[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        
        return presenter.getMessages()[indexPath.item].senderId == self.senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        
        return nil
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {

        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString? {

        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
  
        return 0.0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAt indexPath: IndexPath) -> CGFloat {
        
        return 0.0
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
        // indicator sender
        reload()
    }
    
    func showMessage(msg: String) {
        
    }
}
