//
//  PasswordChangeView.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 13/09/2024.
//

import SwiftUI

struct PasswordChangeView: View {
    let user: UserModel
    @Binding var showSignIn: Bool
    @StateObject private var viewModel = PasswordChangeViewModel()
    var body: some View {
        ZStack{
            NavigationStack{
                VStack{
                    CustomTextField(disable: false, title: "Current Password", text: $viewModel.currentPassword)
                        .padding(.vertical,30)
                    CustomTextField(disable: false, title: "New Password", text: $viewModel.newPassword)
                        .padding(.bottom,30)
                    CustomTextField(disable: false, title: "Confirm Password", text: $viewModel.confirmPassword)
                        .padding(.bottom,30)
                    Button {
                        viewModel.changePassword(email: user.email)
                    } label: {
                        Text("Change password")
                    }
                    .largeButton(color: Color.cyan)
                    .disabled(viewModel.confirmPassword == "" || viewModel.newPassword == "")
                    Spacer()

                }
                .padding()
                .alert("", isPresented: $viewModel.showAlert, actions: {
                    Button("OK", role: .cancel){
                        viewModel.signOut()
                        showSignIn = true
                    }
                }, message: {
                    Text(viewModel.alertMessage)
                })
                .navigationTitle("Change Password")
            }
            if viewModel.showProgressView{
                CustomProgressView()
            }
        }
    }
}

#Preview {
    PasswordChangeView(user: UserModel(userId: "", userName: "", email: "", imageUrl: ""), showSignIn: .constant(false))
}
