//
//  ChatView.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import SwiftUI

struct ChatView: View {
    @Binding var showSignIn: Bool
    @StateObject private var viewModel = ChatViewModel()
    var body: some View {
        NavigationStack{
            VStack{
                Text("Hello")
            }
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button {
                        viewModel.signOut()
                    } label: {
                        Image(systemName: "person.circle")
                    }

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
}

#Preview {
    ChatView(showSignIn: .constant(false))
}
