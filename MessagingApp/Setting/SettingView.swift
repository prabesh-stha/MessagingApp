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
        List{
            
            Button("Change Password"){
                viewModel.showSheet = true
            }
            
            Button {
                viewModel.confirmAlert = true
            } label: {
                Text("Log out")
                    .foregroundStyle(.red)
            }

        }
        .sheet(isPresented: $viewModel.showSheet, content: {
            PasswordChangeView(user: user, showSignIn: $showSignIn)
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
        } message: {
            Text(viewModel.message)
        }
    }
}

#Preview {
    SettingView(user: UserModel(userId: "", userName: "", email: "", imageUrl: ""), showSignIn: .constant(false))
}
