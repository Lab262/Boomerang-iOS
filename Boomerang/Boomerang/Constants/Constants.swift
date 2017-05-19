//
//  Constants.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 01/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import Foundation

enum SectionPost: Int {
    case recommended = 0
    case friends = 1
    case city = 2
}

//MARK - Segue Identifiers
struct SegueIdentifiers {
    static let detailThingToInterestedList = "goToInterestedList"
    static let profileToDetailThing = "goToDetailThing"
    static let homeToDetailThing = "goToDetailThing"
    static let transactionToDetailThing = "goToDetailThing"
    static let morePostToDetailThing = "goToDetailThing"
    static let detailThingToProfile = "goToProfile"
    static let transactionToProfile = "goToProfile"
    static let segmentTransactionToTransaction = "goToTransaction"
    static let detailTransactionToEvaluation = "goToEvaluation"
    static let notificationToDetailThing = "goToDetailThing"
    static let detailTransactionToProfile = "goToProfile"
    static let detailTransactionToChat = "goToChat"
    static let detailTransactionToDetailThing = "goToDetailThing"
    static let interestedToChat = "goToChat"
    static let transactionToHistoric = "goToHistoric"
    static let detailThingToRecommended = "goToRecommended"
    static let homeToMorePost = "goToMorePosts"
    
}

//MARK - Storyboard Ids

struct StoryboardIds {
    static let detailView = "detailThingView"
    static let profileView = "profileView"
    static let transactionView = "navigationTransaction"
    static let chatView = "chatView"
}

//MARK - Notification Keys

struct NotificationKeys {
    static let updateSchemes = "updateSchemes"
    static let updateHistoricSchemes = "updateHistoricSchemes"
    static let popToRootHome = "popToRootHome"
    static let popToRootProfile = "popToRootProfile"
    static let popToRootBoomer = "popToRootBoomer"
    static let popToRootSchemes = "popToRootScheme"
    static let popToRootOthers = "popToRootOthers"
}

//MARK - Paginations

struct Paginations {
    static let friends = 3
    static let postsByFriends = 3
    static let postsByCity = 3
    static let schemes = 3
    static let notifications = 3
    static let comments = 3
}

//MARK - Status Scheme Ids

struct StatusSchemeId {
    static let progress = "FGoq2742yY"
}

//MARK - Strings contents
struct TransactionCellStrings {
    static let titleDonate = "Você está doando "
    static let actionDonate = " está te doando "
    static let titleLoan = "Você está emprestando "
    static let actionLoan = " está te emprestando "
    static let titleExchange = "Você está trocando "
    static let actionExchange = " está trocando "
    static let forAction = " para "
}

//MARK - Title Buttons

struct TitleButtons {
    static let enterInterested = "Quero!"
    static let exitInterested = "Perdi interesse"
    static let recommended = "Recomendar"
    static let interestedList = "Lista de interessados"
}

//MARK - Type Post Titles

struct TypePostTitles {
    static let have = "Tenho"
    static let need = "Preciso"
    static let donate = "Doação"
}




