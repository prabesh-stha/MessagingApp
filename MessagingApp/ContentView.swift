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
            if showSignIn{
                NavigationStack{
                    AuthenticationView(showSignIn: $showSignIn)
                }
            }else{
                TabView{
                    NavigationStack{
                        HomeView(showSignIn: $showSignIn)
                            .navigationTitle("Home")
                    }
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                }
            }
        }
            .onAppear{
                Task{
                    do{
                        if try AuthenticationManager.shared.getUser() == nil{
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
