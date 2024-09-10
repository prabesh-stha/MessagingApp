//
//  ChatViewModel.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import Foundation
import Combine

@MainActor
final class ChatViewModel: ObservableObject{
    @Published var chats: [ChatModel] = []
    @Published var users = [String: UserModel]()
    @Published var userId: String = ""
    func getAllChat() async throws{
        guard let auth = try AuthenticationManager.shared.getUser() else { return }
        self.userId = auth.uid
        self.chats = try await ChatManager.shared.getChat(userId: auth.uid)
        for chat in chats {
            if let userId = chat.participants.first(where: { $0 != auth.uid }){
                let user = try await UserManager.shared.getUser(userId: userId)
                users[userId] = user
            }
            
        }
    }
}
