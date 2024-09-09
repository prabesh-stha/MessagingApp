//
//  FieldModifier.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import Foundation
import SwiftUI

struct FieldModifier: ViewModifier{
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.gray.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View{
    func fieldModifier()-> some View{
        modifier(FieldModifier())
    }
}
