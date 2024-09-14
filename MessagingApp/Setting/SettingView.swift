//
//  SettingView.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import SwiftUI

struct SettingView: View {
    let user: UserModel
    @StateObject private var viewModel = SettingViewModel()
    @Binding var showSignIn: Bool
    var body: some View {
        NavigationStack {
            List{
                Button("Change Email"){
                    viewModel.showEmailSheet = true
                }
                
                Button("Change Password"){
                    viewModel.showPasswordSheet = true
                }
                
                Button("Forgot Password"){
                    viewModel.showForgotPasswordSheet = true
                }
                
                Button {
                    viewModel.confirmAlert = true
                } label: {
                    Text("Log out")
                        .foregroundStyle(.red)
                }
                
            }
            .navigationTitle("Setting")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.showEmailSheet, content: {
                EmailChangeView()
            })
            .sheet(isPresented: $viewModel.showPasswordSheet, content: {
                PasswordChangeView(user: user, showSignIn: $showSignIn)
            })
            .sheet(isPresented: $viewModel.showForgotPasswordSheet, content: {
                PasswordForgotView(showSignIn: $showSignIn)
            })
            .alert("Are you sure?", isPresented: $viewModel.confirmAlert, actions: {
                Button("Yes", role: .destructive){
                    viewModel.signOut()
                }
            })
            .alert("", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel){
                    if viewModel.showSignIn{
                        showSignIn = true
                    }else{
                        showSignIn = false
                    }
                }
            }message: {
            Text(viewModel.message)
        }
    }
    }
}

#Preview {
    SettingView(user: UserModel(userId: "", userName: "", email: "", imageUrl: ""), showSignIn: .constant(false))
}
