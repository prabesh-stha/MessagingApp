//
//  ChatView.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import SwiftUI

struct ParticipantView: View {
    let user: UserModel
    var body: some View {
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
            Text(user.userName)
        }
    }
}

struct ChatView: View {
    @Binding var showSignIn: Bool
    @StateObject private var viewModel = ChatViewModel()
    
    
    var body: some View {
        NavigationStack {
           
            VStack {
                if viewModel.chats.isEmpty{
                    Text("No chats found")
                }else{
                List {
                        ForEach(viewModel.chats, id: \.chatId) { chat in
                            NavigationLink {
                                MessageView(chatId: chat.chatId, userId: viewModel.userId, receiverId: chat.participants.first(where: {$0 != viewModel.userId }) ?? "Unknown")
                            } label: {
                                HStack {
                                    ForEach(chat.participants.filter { $0 != viewModel.userId }, id: \.self) { participantId in
                                        if let user = viewModel.users[participantId] {
                                            ParticipantView(user: user)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    

                }
                    
            }
            .onAppear {
                Task {
                    do {
                        try await viewModel.getAllChat()
                    } catch {
                        print("Error while fetching chat")
                    }
                }
            }
            .onChange(of: viewModel.showSheet, { oldValue, newValue in
                Task {
                    do {
                        try await viewModel.getAllChat()
                    } catch {
                        print("Error while fetching chat")
                    }
                }
            })
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button {
                        viewModel.showSheet = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundStyle(.black)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showSheet, content: {
                NewChatView()
        })
        }
    }
}

#Preview {
    ChatView(showSignIn: .constant(false))
}
