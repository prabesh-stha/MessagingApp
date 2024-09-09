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
}
