//
//  ContentView.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 08/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var showSignIn: Bool = false
    var body: some View {
        ZStack{
            if !showSignIn{
                TabView{
                    NavigationStack{
                        ChatView(showSignIn: $showSignIn)
                            .navigationTitle("Messages")
                    }
                    .tabItem {
                        Label("Chats", systemImage: "message")
                    }
                    NavigationStack{
                        ProfileView(showSignIn: $showSignIn)
                            .navigationTitle("Profile")
                    }
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showSignIn, content: {
            NavigationStack{
                AuthenticationView(showSignIn: $showSignIn)
            }
        })
            .onAppear{
                Task{
                    do{
                        let user = try AuthenticationManager.shared.getAuthenticatedUser()
                        if  user == nil{
                            showSignIn = true
                        }
                        else{
                            showSignIn = false
                        }
                    }
                }
            }
        

    }
}

#Preview {
    ContentView()
}
