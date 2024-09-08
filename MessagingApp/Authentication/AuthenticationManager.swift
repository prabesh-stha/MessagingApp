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
}
