//
//  ChatManager.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 10/09/2024.
//

import Foundation
import Firebase
import Combine

final class ChatManager{
    static let shared = ChatManager()
    private init() {}
    
    private let chatReference = Firestore.firestore().collection("chats")
    
    private func chatCollection(chatId: String) -> DocumentReference{
        chatReference.document(chatId)
    }
    
    private func messageReference(chatId: String) -> CollectionReference{
        chatCollection(chatId: chatId).collection("messages")
    }
    
    private func messageCollection(chatId: String, messageId: String) -> DocumentReference{
        messageReference(chatId: chatId).document(messageId)
    }
    
    @discardableResult
    func createNewChat(chat: ChatModel) async throws -> String{
        let document = chatReference.document()
        let documentId = document.documentID
        let data: [String: Any] = [
            ChatModel.CodingKeys.chatId.rawValue : documentId,
            ChatModel.CodingKeys.participants.rawValue : chat.participants
        ]
        try await document.setData(data, merge: false)
        return documentId
    }
    
    func getChat(userId: String) async throws -> [ChatModel]{
        var chats: [ChatModel] = []
        let querySnapshot = try await chatReference.whereField(ChatModel.CodingKeys.participants.rawValue, arrayContains: userId).getDocuments()
        
        for document in querySnapshot.documents{
           let chat =  try document.data(as: ChatModel.self)
            chats.append(chat)
        }
        return chats
    }
    
    func addMessage(chatId: String, message: MessageModel) async throws{
        let document = messageReference(chatId: chatId).document()
        let documentId = document.documentID
        let data: [String: Any] = [
            MessageModel.CodingKeys.messageId.rawValue : documentId,
            MessageModel.CodingKeys.senderId.rawValue : message.senderId,
            MessageModel.CodingKeys.text.rawValue : message.text,
            MessageModel.CodingKeys.timestamp.rawValue : message.timestamp
        ]
        try await document.setData(data, merge: false)
    }
    func addMessageSnapshotListener(chatId: String) -> AnyPublisher<[MessageModel], Error>{
        let publisher = PassthroughSubject<[MessageModel], Error>()
        messageReference(chatId: chatId).order(by: MessageModel.CodingKeys.timestamp.rawValue, descending: false).addSnapshotListener { querySnapshot, error in
            guard let querySnapshot else{ return}
            let messages = querySnapshot.documents.compactMap { document in
                try? document.data(as: MessageModel.self)
            }
            publisher.send(messages)
        }
        return publisher.eraseToAnyPublisher()
    }
    
    func checkExistingChat(userId1: String, userId2: String) async throws -> ChatModel?{
        var chat: ChatModel?
        let querySnapshot = try await chatReference.whereField(ChatModel.CodingKeys.participants.rawValue, arrayContains: userId1).getDocuments()
        for document in querySnapshot.documents{
            let data = try document.data(as: ChatModel.self)
            if data.participants.contains(userId2){
                chat = data
            }
        }
        return chat
    }
    
    func deleteChat(chatId: String)async throws{
        try await deleteMessages(in: chatId)
       try await chatCollection(chatId: chatId).delete()
    }
    
    private func deleteMessages(in chatId: String) async throws {
        let messagesRef = messageReference(chatId: chatId)
        let querySnapshot = try await messagesRef.getDocuments()
        for document in querySnapshot.documents {
            try await document.reference.delete()
        }
    }
//
//    func getChat(userId: String) -> AnyPublisher<[ChatModel], Error>{
//        let publisher = PassthroughSubject<[ChatModel], Error>()
//        chatReference.whereField(ChatModel.CodingKeys.participants.rawValue, arrayContains: userId).addSnapshotListener { querySnapshot, error in
//            guard let querySnapshot else{
//                print("No document.")
//                return
//            } 
//            var chats = querySnapshot.documents.compactMap { document in
//               try? document.data(as: ChatModel.self)
//            }
//            publisher.send(chats)
//        }
//        return publisher.eraseToAnyPublisher()
//    }
    
}
