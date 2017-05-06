//
//  ChatTableViewCell.swift
//  Boomerang
//
//  Created by Thiago-Bernardes on 14/11/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    static var cellIdentifier = "ChatTableViewCell"
    
    
    @IBOutlet weak var chatMessageLabel: UILabel!
    @IBOutlet weak var chatMessageContainer: UIView!
    @IBOutlet weak var chatContainerTrailingConstraintMyMessage: NSLayoutConstraint!
    @IBOutlet weak var chatContainerLeadingConstraintMyMessage: NSLayoutConstraint!
    @IBOutlet weak var chatContainerTrailingConstraintFriendMessage: NSLayoutConstraint!
    @IBOutlet weak var chatContainerLeadingConstraintFriendMessage: NSLayoutConstraint!
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.window?.endEditing(true)
    }
    
    var chatMessageData : MessageModel! {
        didSet {
            self.setupCell()
        }
    }
    
    func setupCell() {
        self.chatMessageLabel.text = chatMessageData.content
    }
    
    override func layoutSubviews() {
        if chatMessageData.boomerSender == DefaultsHelper.sharedInstance.email {
            self.setupMyMessageStyle()
            
        } else {
            //self.setupMyMessageStyle()
            self.setupFriendMessageStyle()
        }
        super.layoutSubviews()
    }
    
    func setupMyMessageStyle() {
   
        self.chatMessageContainer.backgroundColor = UIColor.myMessageChatBackgroundColor
        self.chatMessageLabel.textColor = UIColor.myMessageChatTextColor
        self.chatContainerTrailingConstraintFriendMessage.isActive = true
        self.chatContainerLeadingConstraintFriendMessage.isActive = true
        self.chatContainerTrailingConstraintMyMessage.isActive = false
        self.chatContainerLeadingConstraintMyMessage.isActive = false
        self.layoutIfNeeded()
    }
    
    func setupFriendMessageStyle() {
        
        self.chatMessageContainer.backgroundColor = UIColor.friendMessageChatBackgroundColor
        self.chatMessageLabel.textColor = UIColor.friendMessageChatTextColor
        self.chatContainerTrailingConstraintFriendMessage.isActive = false
        self.chatContainerLeadingConstraintFriendMessage.isActive = false
        self.chatContainerTrailingConstraintMyMessage.isActive = true
        self.chatContainerLeadingConstraintMyMessage.isActive = true
        self.layoutIfNeeded()
    }
    
}
