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
    @State private var showPassword: Bool = false
    @State private var showProgressView: Bool = false
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading){
                Text("Email")
                    .font(.headline)
                    .padding(.horizontal, 3)
                TextField("Enter email", text: $viewModel.email)
                    .fieldModifier()
                Text("Password")
                    .font(.headline)
                    .padding(.horizontal, 3)
                HStack{
                    if showPassword{
                        TextField("Enter password", text: $viewModel.password)
                            .fieldModifier()
                    }else{
                        SecureField("Enter password", text: $viewModel.password)
                            .fieldModifier()
                    }
                    

                }.overlay(alignment: .trailing) {
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                    }
                    .padding()
                }
                
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
            .padding()
        }

    }
}

#Preview {
        EmailView(showSignIn: .constant(false))
}
