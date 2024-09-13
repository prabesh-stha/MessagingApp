//
//  AuthenticationManager.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import Foundation
import FirebaseAuth

final class AuthenticationManager{
    static let shared = AuthenticationManager()
    private init(){}
    @discardableResult
    func signIn(email: String, password: String) async throws -> AuthenticationModel{
        let auth = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthenticationModel(user: auth.user)
    }
    
    @discardableResult
    func getUser() throws -> AuthenticationModel?{
        let auth = Auth.auth().currentUser
        if let auth{
            return AuthenticationModel(user: auth)
        }else{
            return nil
        }
    }
    
    func signOut() throws{
        try Auth.auth().signOut()
    }
    
    func delete() async throws{
        guard let user = Auth.auth().currentUser else{ throw URLError(.badURL)}
        try await user.delete()
    }
    
    func reAuthentication(email: String, password: String) async throws{
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        guard let user = Auth.auth().currentUser else { throw URLError(.badURL)}
        try await user.reauthenticate(with: credential)
    }
    
    func updatePassword(password: String) async throws{
        guard let user = Auth.auth().currentUser else{ throw URLError(.badURL)}
        try await user.updatePassword(to: password)
    }
}
