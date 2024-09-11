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
    

    func signIn() async throws -> Bool{
        var showHome: Bool = false
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
        return showHome
    }
}
