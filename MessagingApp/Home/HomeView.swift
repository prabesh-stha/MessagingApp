//
//  HomeView.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import SwiftUI

struct HomeView: View {
    @Binding var showSignIn: Bool
    var body: some View {
        VStack{
            Text("Hello")
        }
        
    }
}

#Preview {
    HomeView(showSignIn: .constant(false))
}
