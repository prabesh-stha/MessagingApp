//
//  PasswordChangeViewModel.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 13/09/2024.
//

import Foundation

@MainActor
final class PasswordChangeViewModel: ObservableObject{
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var showProgressView: Bool = false
    @Published var passwordError: String? = nil
    
    
    func validate() -> Bool{
        var isValid: Bool = true
        if newPassword == confirmPassword{
            passwordError = nil
        }
        if newPassword != confirmPassword{
            passwordError = "Password doesn't match"
            isValid = false
        }
        if !FormValidation.validatePassword(newPassword){
            passwordError = "Password must be at least 8 characters long, contain at least one letter, and at least one number."
            isValid = false
        }
        return isValid
    }
    
    func changePassword(email: String){
        guard validate() else { return }
        Task{
                do{
                    showProgressView = true
                    try await AuthenticationManager.shared.reAuthentication(email: email, password: currentPassword)
                     try await AuthenticationManager.shared.updatePassword(password: newPassword)
                    showProgressView = false
                    showAlert = true
                    alertMessage = "Password changed!"
                    
                }catch{
                    showProgressView = false
                    showAlert = true
                    alertMessage = "Failed changing password"
                }
        }
    }
    
    func signOut(){
        try? AuthenticationManager.shared.signOut()
    }
}
