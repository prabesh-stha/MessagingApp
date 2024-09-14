//
//  PasswordForgetViewModel.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 14/09/2024.
//

import Foundation
import FirebaseAuth
@MainActor
final class PasswordForgetViewModel: ObservableObject{
    @Published var email: String = ""
    @Published var user: User? = nil
    @Published var showAlert: Bool = false
    @Published var showProgressView: Bool = false
    @Published var alertMessage: String = ""
    @Published var emailError: String? = nil
    
    func validate() -> Bool{
        if !FormValidation.isValidEmail(email){
            emailError = "Please enter valid email"
            return false
        }else{
            emailError = nil
            return true
        }
    }

    func forgetPassword(){
        guard validate() else{ return }
        Task{
            user = AuthenticationManager.shared.getUser()
            if user == nil{
                do{
                    showProgressView = true
                    try await AuthenticationManager.shared.forgetPassword(email: email)
                    showProgressView = false
                    showAlert = true
                    alertMessage = "Email sent to \(email.lowercased())"
                }catch{
                    showProgressView = false
                    showAlert = true
                    alertMessage = "Email couldn't sent to \(email.lowercased())"
                }
            }else{
                if email.lowercased() == user?.email{
                    do{
                        showProgressView = true
                        try await AuthenticationManager.shared.forgetPassword(email: email)
                        showAlert = true
                        alertMessage = "Email sent to \(email.lowercased())"
                        try AuthenticationManager.shared.signOut()
                    }catch{
                        showProgressView = false
                        showAlert = true
                        alertMessage = "Email couldn't sent to \(email.lowercased())"
                    }
                }else{
                    showAlert = true
                    alertMessage = "Email couldn't sent to \(email.lowercased())"
                }
            }
        }
        
    }
}
