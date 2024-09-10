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
        ZStack {
            NavigationStack {
                VStack {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .padding(.bottom, 100)
                    
                    CustomTextField(text: $viewModel.email, icon: "envelope", placeholder: "Email")
                        .padding(.bottom, 25)
                    
                    CustomSecureFiled(text: $viewModel.password, icon: "lock", placeholder: "Password")
                        .padding(.bottom, 30)
                    
                    VStack {
                        Button {
                            Task{
                                showSignIn = try await !viewModel.signIn()
                                
                            }
                        } label: {
                            Text("Sign In")
                                .largeButton(color: Color.blue)
                        }
                    }
                }
                .alert("", isPresented: $viewModel.showAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(viewModel.message)
                }
                .padding()
                Spacer()
                
                NavigationLink {
                    NewUserFormView(showSignIn: $showSignIn)
                } label: {
                    VStack {
                        Text("Not a member?")
                        Text("Create an account")
                            .font(.headline)
                            .padding()
                            .foregroundStyle(Color.white)
                            .background(Color.purple)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                    }
                }
                .navigationTitle("Sign in")
            }
            if viewModel.showProgressView {
                CustomProgressView()
                
                
            }
        }
        
    }
}

#Preview {
    EmailView(showSignIn: .constant(false))
}
