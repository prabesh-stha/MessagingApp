//
//  MessageModel.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 10/09/2024.
//

import Foundation

struct MessageModel: Codable, Equatable{
    let messageId: String
    let senderId: String
    let text: String
    let timestamp: Date
    
    init(messageId: String, senderId: String, text: String, timestamp: Date) {
        self.messageId = messageId
        self.senderId = senderId
        self.text = text
        self.timestamp = timestamp
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.messageId = try container.decode(String.self, forKey: .messageId)
        self.senderId = try container.decode(String.self, forKey: .senderId)
        self.text = try container.decode(String.self, forKey: .text)
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
    }
    
    enum CodingKeys: String, CodingKey {
        case messageId = "message_id"
        case senderId = "sender_id"
        case text = "text"
        case timestamp = "timestamp"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.messageId, forKey: .messageId)
        try container.encode(self.senderId, forKey: .senderId)
        try container.encode(self.text, forKey: .text)
        try container.encode(self.timestamp, forKey: .timestamp)
    }
}
