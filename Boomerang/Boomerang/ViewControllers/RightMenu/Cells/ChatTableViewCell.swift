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
    @IBOutlet weak var friendChatBaloomImage: UIImageView!
    
    @IBOutlet weak var myChatBaloomImage: UIImageView!
    
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
            self.setupFriendMessageStyle()
        }
        super.layoutSubviews()
    }
    
    func setupMyMessageStyle() {
        
        self.myChatBaloomImage.isHidden = false
        self.friendChatBaloomImage.isHidden = true
        self.chatMessageContainer.backgroundColor = UIColor.myMessageChatBackgroundColor
        self.chatMessageContainer.layer.borderColor = UIColor.myMessageChatBorderColor.cgColor
        self.chatMessageLabel.textColor = UIColor.myMessageChatTextColor
        self.chatContainerTrailingConstraintFriendMessage.isActive = false
        self.chatContainerLeadingConstraintFriendMessage.isActive = false
        self.chatContainerTrailingConstraintMyMessage.isActive = true
        self.chatContainerLeadingConstraintMyMessage.isActive = true
        self.layoutIfNeeded()
    }
    
    func setupFriendMessageStyle() {
        
        self.myChatBaloomImage.isHidden = true
        self.friendChatBaloomImage.isHidden = false
        self.chatMessageContainer.backgroundColor = UIColor.friendMessageChatBackgroundColor
        self.chatMessageContainer.layer.borderColor = UIColor.friendMessageChatBorderColor.cgColor
        self.chatMessageLabel.textColor = UIColor.friendMessageChatTextColor
        self.chatContainerTrailingConstraintMyMessage.isActive = false
        self.chatContainerLeadingConstraintMyMessage.isActive = false
        self.chatContainerTrailingConstraintFriendMessage.isActive = true
        self.chatContainerLeadingConstraintFriendMessage.isActive = true
        self.layoutIfNeeded()
    }
    
}
