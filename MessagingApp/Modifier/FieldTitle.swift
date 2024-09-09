//
//  FieldTitle.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import Foundation
import SwiftUI

struct FieldTitle: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .padding(.horizontal, 3)
    }
}

extension View{
    func fieldTitle() -> some View{
        modifier(FieldTitle())
    }
}
