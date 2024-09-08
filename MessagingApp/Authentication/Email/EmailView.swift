//
//  EmailView.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import SwiftUI

struct EmailView: View {
    @StateObject private var viewModel =  EmailViewModel()
    @Binding var showSignIn: Bool
    var body: some View {
        NavigationStack {
            VStack{
                TextField("Enter email", text: $viewModel.email)
                TextField("Enter password", text: $viewModel.password)
                
                Button {
                    Task{
                        do{
                            try await viewModel.signIn()
                            showSignIn = false
                        }catch{
                            print("error")
                        }
                    }
                } label: {
                    Text("Sign In")
                }
            }
        }

    }
}

#Preview {
        EmailView(showSignIn: .constant(false))
}
