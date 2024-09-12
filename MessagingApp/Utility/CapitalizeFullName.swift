//
//  CapitalizeFullName.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 10/09/2024.
//

import SwiftUI

extension String {
    func capitalizeFirstLetters() -> String {
        return self.split(separator: " ")
            .map { $0.capitalized }
            .joined(separator: " ")
    }
        func capitalizeFirstLetter() -> String {
            self.prefix(1).capitalized + self.dropFirst()
            }
    
    func firstName() -> String?{
        self.components(separatedBy: " ").first?.capitalizeFirstLetter()
    }


}
