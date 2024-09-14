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
        
            NavigationStack {
                ZStack {
                    Color.gray
                        .opacity(0.5)
                        .ignoresSafeArea()
                VStack {
                    Image("ChatSwift")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .padding(.bottom)
                        .padding(.top)
                    NavigationLink {
                        EmailView(showSignIn: $showSignIn)
                    } label: {
                        Text("Sign in with email")
                            .largeButton(color: Color.cyan)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    AuthenticationView(showSignIn: .constant(false))
}
