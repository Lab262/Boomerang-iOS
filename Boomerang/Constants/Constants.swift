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

//MARK - Facebook Urls

struct FacebookUrls {
    static let graph = "https://graph.facebook.com/"
    static let pictureLarge = "/picture?type=large"
}

//MARK - Facebook Params

struct FacebookParams {
    static let id = "id"
    static let publicProfile = "public_profile"
    static let email = "email"
    static let firstName = "first_name"
    static let lastName = "last_name"
    static let userFriends = "user_friends"
    static let fieldsKey = "fields"
    static let meGraphPath = "me"
}

//MARK - Image File Key

struct ImageFile {
    static let jpeg = "image/jpeg"
}

//MARK - Instalation Key

struct InstalationKey {
    static let user = "user"
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
    static let searchFriendsToProfile = "goToProfile"
    static let notificationToSchemeDetail = "goToSchemeDetail"
    static let homeToProfile = "goToProfile"
    static let morePostToProfile = "goToProfile"
    static let profileToFriendsList = "goToFriendsList"
    static let friendsListToProfile = "goToProfile"
    static let chatToPofile = "goToProfile"
}

//MARK - Storyboard Ids

struct StoryboardIds {
    static let detailView = "detailThingView"
    static let profileView = "profileView"
    static let transactionView = "navigationTransaction"
    static let chatView = "chatView"
    static let schemeDetailView = "schemeDetailView"
    
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
    static let friends = 10
    static let facebookFriends = 20
    static let postsFeatureds = 4
    static let postsByFriends = 3
    static let postsByCity = 3
    static let schemes = 3
    static let notifications = 3
    static let comments = 1
    static let morePosts = 2
    static let messages = 100
    static let profiles = 20
    static let pagination = 10
    static let recommendations = 10
    
}

//MARK - Status Scheme Ids

struct StatusSchemeId {
    static let progress = "TDfrBSLDAg"
    static let finished = "FRuVXEtdMr"
    static let canceled = "cFGJX3N8cV"
    static let negotiation = "DCpFv8IIVz"
    static let done = "4CAG7MqCem"
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

//MARK - Detail Post Title

struct DetailPostTitles {
    static let titleNeedChangeOrLoan = "Posso trocar/emprestar"
    static let titleHaveChangeOrLoan = "Quero em troca/emprestado"
    static let titleTime = "Tempo que preciso emprestado"
    static let titlePlace = "Local de retirada"
    
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
    static let enterInterestedList = "enterInterestedList"
    static let likePost = "likePost"
    static let validatePromoCode = "validatePromoCode"
    static let averageStars = "averageStars"
}

//MARK - Server keys

struct ServerKeys {
    static let include = "include"
    static let pagination = "pagination"
}

//MARK - Post keys

struct PostKeys {
    static let author = "author"
    static let photos = "photos"
    static let isAvailable = "isAvailable"
    static let type = "type"
    static let title = "title"

}

//MARK - Interested Keys

struct InterestedKeys {
    static let user = "user"
    static let post = "post"
}

//MARK - Recommended Keys

struct RecommendedKeys {
    static let sender = "sender"
    static let post = "post"
    static let receiver = "receiver"
}

//MARK - Like Keys

struct LikeKeys {
    static let profile = "profile"
    static let post = "post"
}

//MARK - Follow keys

struct FollowKeys {
    static let from = "from"
    static let to = "to"
}

//MARK - User keys

struct UserKeys {
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let userName = "username"
    static let email = "email"
    static let photo = "photo"
    static let profile = "profile"
}

//MARK - Profile keys

struct ProfileKeys {
    static let facebookId = "facebookId"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let email = "email"
    static let photo = "photo"
}

//MARK - Notification keys

struct NotificationModelKeys {
    static let receiver = "receiver"
    static let hasBeenSeen = "hasBeenSeen"
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
    static let owner = "owner"
    static let requester = "requester"
    static let post = "post"
    static let messages = "messages"
}

struct MessageKeys {
    static let user = "user"
    static let chatId = "chatId"
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

//MARK - Evaluation Titles

struct EvaluationTransactionTitles {
    static let evaluateTitle = "Avalie "
    static let evaluateDescription = " e nos diga como foi a sua experiência com ela."
    
}

//MARK - Create Post Titles

struct CreatePostTitles {
    static let borrowed = "Emprestado"
    static let toSwitch = "Para troca"
    static let validated = "Tá valendo"
    static let notValidated = "Ñ tá valendo"
    static let titleDescription = "Descrição"
    static let titleChangeBorrowed = "O que posso dar em troca ou emprestado?"
    static let titleNeed = "Título do Preciso"
    static let placeholderTitleNeed = "Digite aqui"
    static let titleHave = "Título do que Tenho"
    static let placeholderTitleHave = "Digite aqui"
    static let titleDonate = "Título Doação"
    static let placeholderTitleDonate = "Digite aqui"
    static let titleHowLong = "Por quanto tempo (se for emprestado)"
    static let titlePlace = "Local de retirada"
    static let placeholderConversation = "Na base da conversa é o default"
    
    //Keys form create
    static let keyBorrowOrChange = "borrowOrChange"
    static let keyTitle = "titlePost"
    static let keyDescription = "descriptionPost"
    static let keyHowLong = "howLong"
    static let keyHaveBorrowOrChange = "haveBorrowOrChange"
    static let keyPlace = "placePost"
    static let keyAvailable = "available"
    
    //Keys parse forms
    static let keyParseTitle = "title"
    static let keyParseContent = "content"
    static let keyParseExchangeDescription = "exchangeDescription"
    static let keyParsePlace = "place"
    static let keyParseTime = "loanTime"
    
    //Messages erros form
    static let msgErrorImage = "Nenhuma imagem foi selecionada!"
    static let msgErrorTitle = "Campo de Título inválido!"
    static let msgErrorDescription = "Campo de Descrição inválido!"
    static let msgErrorPlace = "Campo de Local de retirada inválido!"
    static let msgErrorIsAvailable = "Opção de Tá valendo não selecionada!"
    static let msgErrorTypeScheme = "Opção de Tipo do Esquema não selecionada!"
    static let msgErrorTime = "Campo de Por quanto tempo inválido!"
    static let msgErrorExchangeDescription = "Campo de O que posso dar em troca inválido!"
}

//MARK - Onboard strings
struct OnboardKeyLogin {
    static let keyLoginFirstTime = "keyLoginFirstTime"
}

struct OnboardCellKeys {
    static let keyImageView = "keyImageView"
    static let keyDescriptionLabel = "keyDescriptionLabel"
}

struct OnboardLoginCellStrings {
    static let firstCell = "Bem vindo a rede social mais amorzinho que você respeita"
    static let secondCell = "Aqui todo mundo se conhece! Nossa rede é feita de amigos para amigos."
    static let thirdCell = "Entre com o Facebook para conseguir o código boomer"
}

struct OnboardLoginCellImages {
    static let firstCell = #imageLiteral(resourceName: "iconFirstPageLogin")
    static let secondCell = #imageLiteral(resourceName: "iconSecondPageLogin")
    static let thirdCell = #imageLiteral(resourceName: "iconThirdPageLogin")
}

struct OnboardMainCellStrings {
    static let firstCell = "Precisa de alguma coisa? Quer trocar ou doar algo? Posta no Boomer!"
    static let secondCell = "Algum amigo com certeza vai te ajudar!"
    static let thirdCell = "Vocês conversam e já marcam o esquema pelo app!"
    static let fourthCell = "O Boomer é uma rede de amigos, Aproveite!"
}

struct OnboardMainCellImages {
    static let firstCell = #imageLiteral(resourceName: "firstPageOnBoard")
    static let secondCell = #imageLiteral(resourceName: "secondPageOnBoard")
    static let thirdCell = #imageLiteral(resourceName: "thirdPageOnBoard")
    static let fourthCell = #imageLiteral(resourceName: "fourthPageOnBoard")
}
