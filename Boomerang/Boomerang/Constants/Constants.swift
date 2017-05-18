//
//  Constants.swift
//  Boomerang
//
//  Created by Huallyd Smadi on 01/04/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import Foundation

//MARK - Segue Identifiers
struct SegueIdentifiers {
    static let detailThingToInterestedList = "goToInterestedList"
    static let profileToDetailThing = "goToDetailThing"
    static let transactionToDetailThing = "goToDetailThing"
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



