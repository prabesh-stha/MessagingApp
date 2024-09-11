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
            if let user = viewModel.user{
                HStack {
                    if let url = URL(string: user.imageUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .padding(.trailing)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .padding(.trailing)
                        }
                    }
                    Text(user.userName.capitalizeFirstLetters())
                }
            }
            Button {
                viewModel.confirmAlert = true
            } label: {
                Text("Log out")
                    .foregroundStyle(.red)
            }

        }
        .onAppear{
            viewModel.getUser()
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
