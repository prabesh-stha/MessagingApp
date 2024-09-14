//
//  PasswordForgotView.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 14/09/2024.
//

import SwiftUI

struct PasswordForgotView: View {
    @StateObject private var viewModel = PasswordForgetViewModel()
    @Binding var showSignIn: Bool
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    if let emailError = viewModel.emailError{
                        Text(emailError)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                    CustomTextField(disable: false, title: "Email", text: $viewModel.email)
                        .padding(.bottom)
                    Button {
                        viewModel.forgetPassword()
                    } label: {
                        Text("Reset password")
                    }
                    .largeButton(color: Color.cyan)
                    
                    Spacer()

                }
                .padding()
                .alert("", isPresented: $viewModel.showAlert) {
                    Button("OK", role: .cancel){
                        showSignIn = true
                        dismiss()
                    }
                } message: {
                    Text(viewModel.alertMessage)
                }
                .navigationTitle("Forgot Password")

            }
            if viewModel.showProgressView{
                CustomProgressView()
            }
        }
    }
}

#Preview {
    PasswordForgotView(showSignIn: .constant(false))
}
