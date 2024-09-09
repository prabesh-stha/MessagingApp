//
//  FormValidation.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import Foundation
class FormValidation {
        static func isValidEmail(_ email: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }
    
    static func validatePassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    static func isNotEmpty(_ string: String) -> Bool {
        return !string.isEmpty
    }
    
    static func validateFullName(_ fullName: String) -> Bool {
            let nameComponents = fullName.split(separator: " ").map { $0.trimmingCharacters(in: .whitespaces) }
            
            if nameComponents.count < 2 || nameComponents.contains(where: { $0.isEmpty }) {
                return false
            }else{
                return true
            }
        }
}
