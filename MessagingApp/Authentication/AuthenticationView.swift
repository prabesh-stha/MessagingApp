//
//  AuthenticationView.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 08/09/2024.
//

import SwiftUI

struct AuthenticationView: View {
    @Binding var showSignIn: Bool
    var body: some View {
        NavigationStack{
            NavigationLink {
                EmailView(showSignIn: $showSignIn)
            } label: {
                Text("Sign in with email")
            }
        }

    }
}

#Preview {
        AuthenticationView(showSignIn: .constant(false))
}
