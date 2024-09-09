//
//  CustomProgressView.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import SwiftUI

struct CustomProgressView: View {
    @State private var isAnimating = false
       
       // Define different gradients for each dot
       let colors: [Color] = [
        Color.purple,
        Color.teal,
        Color.pink,
        Color.mint,
        Color.indigo
       ]
       
       var body: some View {
           ZStack{
               Color.gray.opacity(0.1)
                   .ignoresSafeArea()
               HStack(spacing: 10) {
                   ForEach(0..<5) { index in
                       Circle()
                           .fill(colors[index]) // Each dot gets a different gradient
                           .frame(width: 15, height: 15)
                           .scaleEffect(self.isAnimating ? 1.0 : 0.5)
                           .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(Double(index) * 0.1), value: isAnimating)
                   }
               }
               .onAppear {
                   self.isAnimating = true
               }

           }
       }
}

#Preview {
    CustomProgressView()
}
