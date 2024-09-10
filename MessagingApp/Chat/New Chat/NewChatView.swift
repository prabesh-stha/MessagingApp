//
//  NewChatView.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 10/09/2024.
//

import SwiftUI

struct NewChatView: View {
    @State private var selectedUser: UserModel?
    @StateObject private var viewModel = NewChatViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                // Display selected user info if any
                if let selectedUser = selectedUser {
                    HStack {
                        AsyncImage(url: URL(string: selectedUser.imageUrl)) { image in
                            image
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        }
                        Text(selectedUser.userName.capitalizeFirstLetters())
                            .padding(.leading)
                    }
                    .padding()
                }

                Spacer()

                // Message Input and Send Button
                HStack {
                    TextEditor(text: $viewModel.text)
                        .padding(.vertical, 6)
                        .foregroundStyle(viewModel.text == "Type a message..." ? Color.gray.opacity(0.5) : Color.black)
                        .frame(height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .onTapGesture {
                            if viewModel.text == "Type a message..." {
                                viewModel.text = ""
                            }
                        }

                    Button {
                        Task {
                            do {
                                if let selectedUser {
                                    try await viewModel.createNewChat(receiverId: selectedUser.userId)
                                    dismiss()
                                }
                            } catch {
                                viewModel.showAlert = true
                                viewModel.alertMessage = "Couldn't send message"
                            }
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding(10)
                            .background((viewModel.text == "Type a message..." || viewModel.text.isEmpty) ? Color.gray : Color.blue)
                            .clipShape(Circle())
                            .foregroundColor(Color.white)
                    }
                    .disabled(viewModel.text == "Type a message..." || viewModel.text.isEmpty || selectedUser == nil)
                }
                .padding()
            }
            .toolbar {
                // Menu with options excluding the current user
                ToolbarItem(placement: .confirmationAction) {
                    Menu {
                        ForEach(viewModel.users.filter { $0.userId != viewModel.userId }, id: \.userId) { user in
                            Button(action: {
                                selectedUser = user
                            }) {
                                HStack {
                                    Text(user.userName.capitalizeFirstLetters())
                                    Spacer()
                                    AsyncImage(url: URL(string: user.imageUrl)) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 20, height: 20)
                                            .clipShape(Circle())
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading) // Full-width list item
                            }
                        }
                    } label: {
                        // Menu Button icon changes based on selection
                        HStack {
                            Image(systemName: selectedUser == nil ? "plus" : "pencil")
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                viewModel.getUsers() // Fetch users on appearance
            }
            .alert("Failed", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
}

#Preview {
    NewChatView()
}
