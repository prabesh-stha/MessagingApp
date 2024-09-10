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
                    Image("ChatSwift")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .padding(.bottom)
                        .padding(.top)
                        
                    
                    CustomTextField(text: $viewModel.email, icon: "envelope", placeholder: "Email")
                        .padding(.bottom, 25)
                    
                    CustomSecureFiled(text: $viewModel.password, icon: "lock", placeholder: "Password")
                        .padding(.bottom, 30)
                    
                        Button {
                            Task{
                                showSignIn = try await !viewModel.signIn()
                                
                            }
                        } label: {
                            Text("Sign In")
                                .largeButton(color: Color.blue)
                        }
                        .padding(.bottom, 20)
                    
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
                }
                .alert("", isPresented: $viewModel.showAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(viewModel.message)
                }
                .padding()
                
            if viewModel.showProgressView {
                CustomProgressView()
                
                
            }
        }
        .ignoresSafeArea()
        
    }
}

#Preview {
    EmailView(showSignIn: .constant(false))
}
