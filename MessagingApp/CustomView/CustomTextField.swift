//
//  CustomTextField.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 12/09/2024.
//

import SwiftUI

struct CustomTextField: View {
    let disable: Bool
    let title: String
    @Binding var text: String
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.gray, lineWidth: 1)
                .frame(height: 50)
            TextField("", text: $text)
                .padding(.horizontal, 20)
                .frame(height: 50)
                .disabled(disable)
            Text(title)
                .background(Color.white)
                .foregroundColor(.gray)
                .padding(.horizontal, 10)
                .padding(.top, -10)
                .padding(.leading, 20)
        }
    }
}

#Preview {
    CustomTextField(disable: false, title: "Name", text: .constant(""))
}
