//
//  LargeButtonModifier.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import Foundation
import SwiftUI

struct LargeButtonModifier: ViewModifier{
    var color: Color
    func body(content: Content) -> some View{
        content
            .font(.headline)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .frame(height: 55)
            .foregroundStyle(Color.white)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)
            
    }
}

extension View{
    func largeButton(color: Color) -> some View{
        modifier(LargeButtonModifier(color: color))
    }
}
