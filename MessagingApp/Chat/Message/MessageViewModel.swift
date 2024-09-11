//
//  MessageViewModel.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 10/09/2024.
//

import Foundation
import Combine
@MainActor
final class MessageViewModel: ObservableObject{
    @Published var messages: [MessageModel] = []
    @Published var text: String = "Type a message..."
    @Published var receiver: UserModel?
    private var cancellable = Set<AnyCancellable>()
    
    
    func getMessage(chatId: String){
        ChatManager.shared.addMessageSnapshotListener(chatId: chatId)
            .sink { completion in
                
            } receiveValue: { [weak self] messages in
                self?.messages = messages
            }
            .store(in: &cancellable)

            
    }
    
    func sendMessage(chatId: String, userId: String) async throws{
        try await ChatManager.shared.addMessage(chatId: chatId, message: MessageModel(messageId: "", senderId: userId, text: text, timestamp: Date.now))
    }
    
    func getUser(userId: String) {
        
        Task{
            do{
                self.receiver = try await UserManager.shared.getUser(userId: userId)
            }
        }
    }

    
}

