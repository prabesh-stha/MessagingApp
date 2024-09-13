//
//  EmailChangeView.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 13/09/2024.
//

import SwiftUI

struct EmailChangeView: View {
    @StateObject private var viewModel = EmailChangeViewModel()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    CustomTextFieldWithIcon(text: $viewModel.oldEmail, icon: "person", placeholder: "Old Email")
                        .padding(.bottom, 30)
                    
                    CustomTextFieldWithIcon(text: $viewModel.newEmail, icon: "person", placeholder: "New Email")
                        .padding(.bottom, 30)
                    
                    CustomSecureFiled(text: $viewModel.password, icon: "lock", placeholder: "Password")
                        .padding(.bottom, 30)
                    
                    if viewModel.isCheckingVerification {
                        Button(action: {
                            Task {
                                await viewModel.checkEmailVerification()
                            }
                        }) {
                            Text("I have verified my email")
                                .largeButton(color: Color.cyan)
                        }
                    }else{
                        Button(action: {
                            Task {
                                await viewModel.sendVerificationAndUpdateEmail()
                            }
                        }) {
                            Text("Send Verification and Update Email")
                                .largeButton(color: Color.cyan)
                        }
                    }
                    
                    Text(viewModel.message)
                        .foregroundColor(.red)
                        .padding()
                    Spacer()
                }
                .alert("", isPresented: $viewModel.showAlert, actions: {
                    Button("OK", role: .cancel){
                        dismiss()
                    }
                }, message: {
                    Text(viewModel.message)
                })
                .padding()
                .navigationTitle("Email Change")
            }
            if viewModel.showProgressView{
                CustomProgressView()
            }
        }
    }

    
}

#Preview {
    EmailChangeView()
}
