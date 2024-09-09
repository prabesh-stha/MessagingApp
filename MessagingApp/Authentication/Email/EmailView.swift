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
            VStack{
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 100)
                CustomTextField(text: $viewModel.email, icon: "person", placeholder: "Email")
                    .padding(.bottom, 25)
                CustomSecureFiled(text: $viewModel.password, showPassword: $showPassword, icon: "lock", placeholder: "Password")
                    .padding(.bottom, 30)
                
                VStack{
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
                            .largeButton(color: Color.blue)
                            
                    }
                }
            }
            .padding()
            Spacer()
            NavigationLink {
                Text("Sign up")
            } label: {
                VStack{
                    Text("Not a member?")
                    Text("Create an account")
                        .font(.headline)
                        .padding()
                        .foregroundStyle(Color.white)
                        .background(Color.purple)
                        .clipShape(RoundedRectangle(cornerRadius: 25))                       }
            }
            .navigationTitle("Sign in")
        }

    }
}

#Preview {
        EmailView(showSignIn: .constant(false))
}
