//
//  ChatModel.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 10/09/2024.
//

import Foundation

struct ChatModel: Codable{
    let chatId: String
    let participants: [String]
    
    init(chatId: String, participants: [String]) {
        self.chatId = chatId
        self.participants = participants
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.chatId = try container.decode(String.self, forKey: .chatId)
        self.participants = try container.decode([String].self, forKey: .participants)
    }
    
    enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
        case participants = "participants"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.chatId, forKey: .chatId)
        try container.encode(self.participants, forKey: .participants)
    }
}
