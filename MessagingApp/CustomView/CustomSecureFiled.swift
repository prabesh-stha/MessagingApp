//
//  CustomSecureFiled.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import SwiftUI

struct CustomSecureFiled: View {
    @Binding var text: String
    @Binding var showPassword: Bool
    let icon: String
    let placeholder: String
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(Color.gray.opacity(0.05))
            .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 3, x: 0, y: 5)
            .frame(height: 55)
            .frame(maxWidth: .infinity)            .overlay(content: {
                HStack{
                    Image(systemName: icon)
                    if showPassword{
                        TextField(placeholder, text: $text)
                    }else{
                        SecureField(placeholder, text: $text)
                    }
                }
                .padding()
                .overlay(alignment: .trailing) {
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundStyle(Color.gray)
                    }
                    .padding(.horizontal)
                }
                
            })
    }
}

#Preview {
    CustomSecureFiled(text: .constant(""), showPassword: .constant(false), icon: "lock", placeholder: "Password")
}
