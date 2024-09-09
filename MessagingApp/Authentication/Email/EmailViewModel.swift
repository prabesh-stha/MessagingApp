//
//  EmailViewModel.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import Foundation

@MainActor
final class EmailViewModel: ObservableObject{
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showProgressView: Bool = false
    @Published var showAlert: Bool = false
    @Published var message: String = ""
    
    @Published var showHome: Bool = false

    func signIn(){
        Task{
            do{
                showProgressView = true
                try await AuthenticationManager.shared.signIn(email: email, password: password)
                showProgressView = false
                showHome = true
            }catch{
                showProgressView = false
                message = "Invalid login attempt"
                showAlert = true
                showHome = false
            }
        }
    }
}
