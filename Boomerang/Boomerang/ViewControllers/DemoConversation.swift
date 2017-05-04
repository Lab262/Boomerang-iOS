//
//  DemoConversation.swift
//  SwiftExample
//
//  Created by Dan Leonard on 5/11/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

import JSQMessagesViewController

// User Enum to make it easyier to work with.
enum UserTest: String {
    case leonard    = "053496-4509-288"
    case squires    = "053496-4509-289"
    case jobs       = "707-8956784-57"
    case cook       = "468-768355-23123"
    case wozniak    = "309-41802-93823"
}

// Helper Function to get usernames for a secific User.
func getName(_ user: UserTest) -> String{
    switch user {
    case .squires:
        return "Jesse Squires"
    case .cook:
        return "Tim Cook"
    case .wozniak:
        return "Steve Wozniak"
    case .leonard:
        return "Dan Leonard"
    case .jobs:
        return "Steve Jobs"
    }
}
//// Create Names to display
//let DisplayNameSquires = "Jesse Squires"
//let DisplayNameLeonard = "Dan Leonard"
//let DisplayNameCook = "Tim Cook"
//let DisplayNameJobs = "Steve Jobs"
//let DisplayNameWoz = "Steve Wazniak"



// Create Unique IDs for avatars
let AvatarIDLeonard = "053496-4509-288"
let AvatarIDSquires = "053496-4509-289"
let AvatarIdCook = "468-768355-23123"
let AvatarIdJobs = "707-8956784-57"
let AvatarIdWoz = "309-41802-93823"

// Create Avatars Once for performance
//
// Create an avatar with Image



let AvatarLeonard = JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: "DL", backgroundColor: UIColor.jsq_messageBubbleGreen(), textColor: UIColor.white, font: UIFont.systemFont(ofSize: 12), diameter: 1)

let AvatarCook = JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: "TC", backgroundColor: UIColor.gray, textColor: UIColor.white, font: UIFont.systemFont(ofSize: 12), diameter: 1)

// Create avatar with Placeholder Image

let AvatarJobs = JSQMessagesAvatarImageFactory.avatarImage(withPlaceholder: UIImage(named:"demo_avatar_jobs")!, diameter: 1)

let AvatarWoz = JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: "SW", backgroundColor: UIColor.jsq_messageBubbleGreen(), textColor: UIColor.white, font: UIFont.systemFont(ofSize: 12), diameter: 1)

let AvatarSquires = JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: "JSQ", backgroundColor: UIColor.gray, textColor: UIColor.white, font: UIFont.systemFont(ofSize: 12), diameter: 1)

// Helper Method for getting an avatar for a specific User.
func getAvatar(_ id: String) -> JSQMessagesAvatarImage{
    let user = UserTest(rawValue: id)!
    
    switch user {
    case .leonard:
        return AvatarLeonard!
    case .squires:
        return AvatarSquires!
    case .cook:
        return AvatarCook!
    case .wozniak:
        return AvatarWoz!
    case .jobs:
        return AvatarJobs!
    }
}



// INFO: Creating Static Demo Data. This is only for the exsample project to show the framework at work.
var conversationsList = [Conversation]()

var convo = Conversation(firstName: "Steave", lastName: "Jobs", preferredName:  "Stevie", smsNumber: "(987)987-9879", id: "33", latestMessage: "Holy Guacamole, JSQ in swift", isRead: false)

var conversation = [JSQMessage]()

let message = JSQMessage(senderId: AvatarIdCook, displayName: getName(.cook), text: "What is this Black Majic?")
let message2 = JSQMessage(senderId: AvatarIDSquires, displayName: getName(.squires), text: "It is simple, elegant, and easy to use. There are super sweet default settings, but you can customize like crazy")
let message3 = JSQMessage(senderId: AvatarIdWoz, displayName: getName(.wozniak), text: "It even has data detectors. You can call me tonight. My cell number is 123-456-7890. My website is www.hexedbits.com.")
let message4 = JSQMessage(senderId: AvatarIdJobs, displayName: getName(.jobs), text: "JSQMessagesViewController is nearly an exact replica of the iOS Messages App. And perhaps, better.")
let message5 = JSQMessage(senderId: AvatarIDLeonard, displayName: getName(.leonard), text: "It is unit-tested, free, open-source, and documented.")


let message6 = JSQMessage(senderId: AvatarIDLeonard, displayName: getName(.leonard), text: "This is incredible")
let message7 = JSQMessage(senderId: AvatarIdWoz, displayName: getName(.wozniak), text: "I would have to agree")
let message8 = JSQMessage(senderId: AvatarIDLeonard, displayName: getName(.leonard), text: "It is unit-tested, free, open-source, and documented like a boss.")
let message9 = JSQMessage(senderId: AvatarIdWoz, displayName: getName(.wozniak), text: "You guys need an award for this, I'll talk to my people at Apple. 💯 💯 💯")

// photo message
let photoItem = JSQPhotoMediaItem(image: UIImage(named: "goldengate"))
let photoMessage = JSQMessage(senderId: AvatarIdWoz, displayName: getName(.wozniak), media: photoItem)

// audio mesage
let sample = Bundle.main.path(forResource: "jsq_messages_sample", ofType: "m4a")
let audioData = try? Data(contentsOf: URL(fileURLWithPath: sample!))
let audioItem = JSQAudioMediaItem(data: audioData)
let audioMessage = JSQMessage(senderId: AvatarIdWoz, displayName: getName(.wozniak), media: audioItem)

func makeGroupConversation()->[JSQMessage] {
    conversation = [message!, message2!,message3!, message4!, message5!, photoMessage!, audioMessage!]
    return conversation
}

func makeNormalConversation() -> [JSQMessage] {
    conversation = [message6!, message7!, message8!, message9!, photoMessage!, audioMessage!]
    return conversation
}
