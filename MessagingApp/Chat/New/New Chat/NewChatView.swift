//
//  NewChatView.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 10/09/2024.
//
import SwiftUI

struct NewChatView: View {
    let userId: String
    @StateObject private var viewModel = NewChatViewModel()
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                TextField("Search Users", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: viewModel.searchText) { oldValue, newValue in
                        viewModel.filteredUsers = viewModel.heuristicSearch(query: newValue, in: viewModel.users)
                    }
                List(viewModel.filteredUsers, id: \.userId) { user in
                    NavigationLink{
                            NewMessageView(userId: userId, receiverId: user.userId)
                    } label: {
                        HStack {
                            if let url = URL(string: user.imageUrl) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                }
                            }
                            Text(user.userName.capitalizeFirstLetters())
                                .padding(.leading)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.getUsers(userId: userId)
            }

        }
    }
}

#Preview {
    NewChatView(userId: ""  )
}
