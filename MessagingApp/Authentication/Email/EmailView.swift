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
                        
                        
                    
                    CustomTextFieldWithIcon(text: $viewModel.email, icon: "envelope", placeholder: "Email")
                        .padding(.bottom, 25)
                    
                    CustomSecureFiled(text: $viewModel.password, icon: "lock", placeholder: "Password")
                        .padding(.bottom, 30)
                    
                        Button {
                            Task{
                                showSignIn = try await !viewModel.signIn()
                                
                            }
                        } label: {
                            Text("Sign In")
                                .largeButton(color: Color.cyan)
                        }
                        .padding(.bottom)
                    
                    Button {
                        viewModel.showForgotPasswordSheet = true
                    } label: {
                        Text("Forgot Password?")
                    }
                    .padding(.bottom, 30)

                    
                    NavigationLink {
                        NewUserFormView(showSignIn: $showSignIn)
                    } label: {
                        HStack {
                            Text("Not a member?")
                                .foregroundStyle(.black)
                            Text("Create an account")
                        }
                    }
                    .navigationTitle("Sign in")
                }
                }
            .sheet(isPresented: $viewModel.showForgotPasswordSheet, content: {
                PasswordForgotView(showSignIn: $showSignIn)
            })
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
