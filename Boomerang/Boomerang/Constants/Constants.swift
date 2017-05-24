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
    static let postsFeatureds = 4
    static let postsByFriends = 3
    static let postsByCity = 3
    static let schemes = 3
    static let notifications = 3
    static let comments = 10
    static let morePosts = 10
    static let messages = 5
}

//MARK - Status Scheme Ids

struct StatusSchemeId {
    static let progress = "FGoq2742yY"
    static let finished = "gTRgdWgkJR"
    static let canceled = "cHsRNXQpWS"
    static let negotiation = "5MxzhBHxB7"
    static let done = "j0MewQGDsX"
    
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

//MARK - Notification Success Messages

struct NotificationSuccessMessages {
    static let enterInterestedList = "Estou interessado, fico feliz em ajudar"
    static let exitInterestedList = "Você saiu da lista de interessados."
}

//MARK - Home Header Titles

struct HomeHeaderTitles {
    static let greeting = "Olar, "
    static let myFriends = "Meus migos"
    static let myCity = "Em Brasília"
}

//MARK - Profile Title

struct ProfileTitles {
    static let follow = "Seguir"
    static let unfollow = "Seguindo"
}

//MARK - PFCloud functions

struct CloudFunctions {
    static let featuredPosts = "featuredPosts"
}

//MARK - Server keys

struct ServerKeys {
    static let include = "include"
    static let pagination = "pagination"
}

//MARK - Post keys

struct PostKeys {
    static let author = "author"
}

//MARK - Follow keys

struct FollowKeys {
    static let from = "from"
}

//MARK - Scheme keys

struct SchemeKeys {
    static let className = "Scheme"
    static let status = "status"
    static let requester = "requester"
    static let owner = "owner"
    static let post = "post"
}

//MARK - Chat keys

struct ChatKeys {
    static let className = "Chat"
    static let messages = "messages"
}



//MARK - Scheme Status keys

struct SchemeStatusKeys {
    static let className = "SchemeStatus"
}



//MARK - PF Object keys

struct ObjectKeys {
    static let updatedAt = "updatedAt"
    static let createdAt = "createdAt"
    static let objectId = "objectId"
    static let isDeleted = "isDeleted"
}

//MARK - Time Ago Strings

struct TimeAgo {
    static let now = "Agora"
    static let oneMin = " minuto atrás"
    static let min = " minutos atrás"
    static let oneHour = " hora atrás"
    static let hour = " horas atrás"
    static let oneDay = " dia atrás"
    static let day = " dias atrás"
    static let oneMonth = " mês atrás"
    static let month = " mêses atrás"
    static let oneYear = " ano atrás"
    static let year = " anos atrás"
}

//MARK - SearchBar placeholder
struct SearchBarTitles {
    static let placeholder = "O que você procura?"
}

//MARK - SearchBar placeholder

struct EvaluationTitles {
    static let placeholder = "Maximo de 140 caracteres, tá bom, migo?"
}

//MARK - Transaction Titles

struct TransactionTitles {
    static let have = "Empréstimo feito com"
    static let donate = "Doação feita com"
    static let need = "Troca feita com"
}
