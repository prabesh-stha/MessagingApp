//
//  UserManager.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import Foundation
import FirebaseFirestore

class UserManager{
    static let shared = UserManager()
    private init(){}
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference{
        userCollection.document(userId)
    }
    
    func getUser(userId: String) async throws -> UserModel{
        try await userDocument(userId: userId).getDocument(as: UserModel.self)
    }
    
    func createNewUser(user: UserModel) async throws{
        let data: [String: Any] =
        [
            UserModel.CodingKeys.userId.rawValue : user.userId,
            UserModel.CodingKeys.userName.rawValue : user.userName.lowercased(),
            UserModel.CodingKeys.email.rawValue : user.email.lowercased(),
            UserModel.CodingKeys.imageUrl.rawValue : user.imageUrl
        ]
        try await userDocument(userId: user.userId).setData(data)
    }
    
    func checkEmail(email: String) async throws -> Bool{
        let document = userCollection.whereField(UserModel.CodingKeys.email.rawValue, isEqualTo: email.lowercased())
        let querySnapshot = try await document.getDocuments()
        var users: [UserModel] = []
        for document in querySnapshot.documents{
            let user = try document.data(as: UserModel.self)
            users.append(user)
        }
        if users.isEmpty{
            return false
        }
        return true
        
    }
    
    func getAllUser() async throws -> [UserModel]{
        var users: [UserModel] = []
        let querySnapshot = try await userCollection.getDocuments()
        for document in querySnapshot.documents{
            let user = try document.data(as: UserModel.self)
            users.append(user)
        }
        return users
    }
    
    func changeName(userId: String, name: String) async throws{
        let data: [String: Any] = [
            UserModel.CodingKeys.userName.rawValue : name
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func changeImageUrl(userId: String, imageUrl: String) async throws{
        let data: [String: Any] = [
            UserModel.CodingKeys.imageUrl.rawValue : imageUrl
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func changeBoth(userId: String, name: String, imageUrl: String) async throws{
        let data: [String: Any] = [
            UserModel.CodingKeys.userName.rawValue : name,
            UserModel.CodingKeys.imageUrl.rawValue : imageUrl
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func changeEmail(userId: String, email: String) async throws{
        let data: [String: Any] = [
            UserModel.CodingKeys.email.rawValue : email.lowercased()
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func deleteUser(userId: String) async throws{
        try await userDocument(userId: userId).delete()
    }
}
