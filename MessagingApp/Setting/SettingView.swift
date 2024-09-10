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
                viewModel.signOut()
            } label: {
                Image(systemName: "person.circle")
            }

        }
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
