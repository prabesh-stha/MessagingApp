//
//  ProfileViewModel.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 11/09/2024.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject{
    @Published var user: UserModel? = nil
    @Published var showAlert: Bool = false
    @Published var showProgressView: Bool = false
    @Published var message: String = ""
    @Published var showSignIn: Bool = false
    @Published var confirmAlert: Bool = false
 
    func signOut(){
        Task{
            do{
                showProgressView = true
                try AuthenticationManager.shared.signOut()
                showProgressView = false
                showAlert = true
                showSignIn = true
                message = "Signed out successfully"
            }catch{
                showProgressView = false
                showAlert = true
                showSignIn = false
                message = "Failed while signing out"
            }
        }
    }
    
    func getUser(){
        Task{
            do{
                if let auth = try AuthenticationManager.shared.getAuthenticatedUser(){
                    user = try await UserManager.shared.getUser(userId: auth.uid)
                }
            }
        }
    }
}
