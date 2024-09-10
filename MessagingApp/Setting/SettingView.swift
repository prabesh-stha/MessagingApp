//
//  SettingView.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var viewModel = SettingViewModel()
    @Binding var showSignIn: Bool
    var body: some View {
        List{
            Button {
                viewModel.confirmAlert = true
            } label: {
                Text("Log out")
                    .foregroundStyle(.red)
            }

        }
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
    SettingView(showSignIn: .constant(false))
}
