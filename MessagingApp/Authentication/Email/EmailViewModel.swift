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

    func signIn() async throws{
        try await AuthenticationManager.shared.signIn(email: email, password: password)
    }
}
