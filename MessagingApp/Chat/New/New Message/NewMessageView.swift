//
//  NewMessageView.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 11/09/2024.
//

import SwiftUI

struct NewMessageView: View {
    let userId: String
    let receiverId: String
    @StateObject private var viewModel = NewMessageViewModel()
    var body: some View {
        ScrollViewReader{scrollViewProxy in
            ScrollView(showsIndicators: false){
                ForEach(viewModel.messages, id: \.messageId) { message in
                    VStack{
                        HStack {
                            if message.senderId == userId {
                                Spacer()
                            }
                            
                            VStack {
                                Text(message.text)
                                    .padding(6)
                                    .background((message.senderId == userId) ? Color.blue : Color.gray.opacity(0.5))
                                    .cornerRadius(8)
                                    .foregroundColor((message.senderId == userId) ? .white : .black)
                                    .frame(maxWidth: 300, alignment: (message.senderId == userId) ? .trailing : .leading)
                                
                                Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                                    .frame(maxWidth: 300, alignment: (message.senderId == userId) ? .trailing : .leading)
                                
                            }
                            if message.senderId != userId {
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                    }
                    .alert("Failed", isPresented: $viewModel.showAlert) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text(viewModel.alertMessage)
                    }
                }
                Spacer()
            }
            
            .onChange(of: viewModel.messages) {
                if let latestMessageId = viewModel.messages.last?.messageId {
                    scrollViewProxy.scrollTo(latestMessageId, anchor: .bottom)
                }
            }
        }
        Divider()
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
                    if viewModel.text == "Type a message..."{
                        viewModel.text = ""
                    }
                }
            
            Button {
                Task{
                    do{
                        try await viewModel.createNewChat(userId: userId, receiverId: receiverId)
                        viewModel.text = ""
                    }catch{
                        viewModel.alertMessage = "Unable to sent"
                        viewModel.showAlert = true
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
            .disabled(viewModel.text == "Type a message..." || viewModel.text.isEmpty)
        }
        .padding()
        .background(Color.white)
        .onAppear(perform: {
            Task{
                do{
                    try await viewModel.getChat(userId: userId, receiverId: receiverId)
                }
            }
            
            
        })
        
    }
}

#Preview {
    NewMessageView(userId: "", receiverId: "")
}
