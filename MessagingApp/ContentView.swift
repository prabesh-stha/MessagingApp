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
                        SettingView(showSignIn: $showSignIn)
                            .navigationTitle("Settings")
                    }
                    .tabItem {
                        Label("Setting", systemImage: "gear")
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
                        let user = try AuthenticationManager.shared.getUser()
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
