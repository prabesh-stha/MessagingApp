//
//  NewMessageViewModel.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 11/09/2024.
//

import Foundation
import Combine

@MainActor
final class NewMessageViewModel: ObservableObject{
    @Published var text: String = "Type a message..."
    @Published var messages: [MessageModel] = []
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    private var cancellable = Set<AnyCancellable>()

    
    private func getMessage(chatId: String){
        ChatManager.shared.addMessageSnapshotListener(chatId: chatId)
            .sink { completion in
                
            } receiveValue: { [weak self] messages in
                self?.messages = messages
            }
            .store(in: &cancellable)

            
    }
    
    func getChat(userId: String, receiverId: String) async throws{
        if let chat = try await ChatManager.shared.checkExistingChat(userId1: userId, userId2: receiverId){
            getMessage(chatId: chat.chatId)
        }
    }
    

    func createNewChat(userId: String, receiverId: String) async throws {
        
            if let chat = try await ChatManager.shared.checkExistingChat(userId1: userId, userId2: receiverId){
                try await ChatManager.shared.addMessage(chatId: chat.chatId, message: MessageModel(messageId: "", senderId: userId, text: text, timestamp: Date.now))
            }else{
                let chatId = try await ChatManager.shared.createNewChat(chat: ChatModel(chatId: "", participants: [userId, receiverId]))
                try await ChatManager.shared.addMessage(chatId: chatId, message: MessageModel(messageId: "", senderId: userId, text: text, timestamp: Date.now))
                getMessage(chatId: chatId)
            }
    }
}
