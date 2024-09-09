//
//  UserModel.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import Foundation

struct UserModel: Codable{
    let userId: String
    let userName: String
    let email: String
    let imageUrl: String
    
    init(userId: String, userName: String, email: String, imageUrl: String) {
        self.userId = userId
        self.userName = userName
        self.email = email
        self.imageUrl = imageUrl
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.userName = try container.decode(String.self, forKey: .userName)
        self.email = try container.decode(String.self, forKey: .email)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
    }
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case userName = "user_name"
        case email = "email"
        case imageUrl = "image_url"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.userName, forKey: .userName)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.imageUrl, forKey: .imageUrl)
    }
}
