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
    @Published var showSheet: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var message: String = ""
    private var cancellable = Set<AnyCancellable>()
    
    func getUserId(){
        Task{
            do {
                if let user = try AuthenticationManager.shared.getAuthenticatedUser(){
                    userId = user.uid
                    getChat()
                }
            }
        }
    }
    func getChat(){
        ChatManager.shared.getChat(userId: userId)
            .sink { _ in
                
            } receiveValue: { [weak self] chats in
                guard let self = self else { return }
                                self.chats = chats
                                
                                Task {
                                    await self.fetchUsers(for: chats)
                                }
            }.store(in: &cancellable)

    }
    private func fetchUsers(for chats: [ChatModel]) async {
        
        for chat in chats {
            for participantId in chat.participants {
                if participantId != userId, self.users[participantId] == nil {
                    do {
                        let user = try await UserManager.shared.getUser(userId: participantId)
                        self.users[participantId] = user
                    } catch {
                        print("Failed to fetch user with id \(participantId): \(error)")
                    }
                }
            }
        }
    }
    
    func deleteChat(chatId: String){
        Task{
            do{
                try await ChatManager.shared.deleteChat(chatId: chatId)
            }catch{
                showErrorAlert = true
                message = "Unable to delete chat."
            }
        }
    }
}
