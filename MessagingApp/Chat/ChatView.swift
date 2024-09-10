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
                        
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundStyle(.black)
                    }

                }
                
            }
        }
    }
}

#Preview {
    ChatView(showSignIn: .constant(false))
}
