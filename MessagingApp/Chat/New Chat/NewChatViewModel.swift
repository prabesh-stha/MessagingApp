//
//  NewChatViewModel.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 10/09/2024.
//

import Foundation

@MainActor
final class NewChatViewModel: ObservableObject{
    @Published var users:[UserModel] = []
    @Published var userId: String? = nil
    @Published var text: String = "Type a message..."
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    func getUserId(){
        Task{
            do{
                userId = try AuthenticationManager.shared.getUser()?.uid
            }
        }
    }
    
    func sendMessage(chatId: String, userId: String) async throws{
        try await ChatManager.shared.addMessage(chatId: chatId, message: MessageModel(messageId: "", senderId: userId, text: text, timestamp: Date.now))
    }
    func getUsers(){
        getUserId()
        Task{
            do{
                self.users = try await UserManager.shared.getAllUser()
            }catch{
                print("Couldn't get users")
            }
        }
    }
    
    func createNewChat(receiverId: String) async throws{
        if let userId{
           let chatId = try await ChatManager.shared.createNewChat(chat: ChatModel(chatId: "", participants: [userId, receiverId]))
            try await ChatManager.shared.addMessage(chatId: chatId, message: MessageModel(messageId: "", senderId: userId, text: text, timestamp: Date.now))
        }
    }
}
