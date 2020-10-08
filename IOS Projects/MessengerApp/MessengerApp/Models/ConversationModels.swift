//
//  ConversationModels.swift
//  MessengerApp
//
//  Created by Mohammad Ashraful Islam Sadi on 28/9/20.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
