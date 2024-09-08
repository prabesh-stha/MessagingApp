//
//  AuthenticationModel.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 08/09/2024.
//

import Foundation
import FirebaseAuth

struct AuthenticationModel: Codable{
    let uid: String
    let email: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}
