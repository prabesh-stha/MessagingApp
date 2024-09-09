//
//  CustomTextField.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    let icon: String
    let placeholder: String
    var body: some View {
       
        RoundedRectangle(cornerRadius: 25)
            .fill(Color.gray.opacity(0.05))
            .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 3, x: 0, y: 5)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            
        .overlay{
            HStack{
                Image(systemName: icon)
                TextField(placeholder, text: $text)
            }
            .padding()
        }
    }
}

#Preview {
    CustomTextField(text: .constant("Email"), icon: "person" ,placeholder: "Email")
}
