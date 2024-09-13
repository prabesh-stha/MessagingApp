//
//  SettingViewModel.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import Foundation
import FirebaseAuth
@MainActor
final class SettingViewModel: ObservableObject{
    @Published var showAlert: Bool = false
    @Published var showProgressView: Bool = false
    @Published var message: String = ""
    @Published var showSignIn: Bool = false
    @Published var confirmAlert: Bool = false
    @Published var showPasswordSheet: Bool = false
    @Published var showEmailSheet: Bool = false
    
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
}
