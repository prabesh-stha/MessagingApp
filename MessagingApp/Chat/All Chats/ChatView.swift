//
//  ChatView.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import SwiftUI

struct ParticipantView: View {
    let user: UserModel?
    var body: some View {
        HStack {
            if let user = user{
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
            }else{
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .padding(.trailing)
                Text("Unknown user")
            }
            
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
                                            ParticipantView(user: viewModel.users[participantId])
                                    }
                                }
                            }
                            .alert("Failed", isPresented: $viewModel.showErrorAlert, actions: {
                                Button("OK", role: .cancel){}
                            })
                            
                            .swipeActions(edge: .trailing, allowsFullSwipe: false){
                                Button(role: .destructive){
                                    viewModel.deleteChat(chatId: chat.chatId)
                                } label: {
                                    Image(systemName: "trash")
                                }

                            }
                        }
                    }
                    

                }
                    
            }
            .onAppear {
                viewModel.getUserId()
            }
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
                NewChatView(userId: viewModel.userId)
        })
        }
    }
}

#Preview {
    ChatView(showSignIn: .constant(false))
}
