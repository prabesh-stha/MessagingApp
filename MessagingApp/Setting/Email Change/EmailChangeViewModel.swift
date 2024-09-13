//
//  EmailChangeViewModel.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 13/09/2024.
//

import Foundation

@MainActor
final class EmailChangeViewModel: ObservableObject{
    @Published var oldEmail: String = ""
    @Published var newEmail: String = ""
    @Published var password: String = ""
    @Published var message: String = ""
    @Published var isCheckingVerification = false
    @Published var isVerified = false
    @Published var emailError: String? = nil
    @Published var showAlert: Bool = false
    @Published var showProgressView: Bool = false
    
    func validate() -> Bool{
        var isValid: Bool = true
        if !FormValidation.isValidEmail(newEmail){
            emailError = "Please enter valid email"
            isValid = false
        }else{
            emailError = nil
        }
        return isValid
    }
    func sendVerificationAndUpdateEmail() async {
        guard validate() else{ return }
        
//        guard let userInfo = AuthenticationManager.shared.getUser() else {
//            self.message = "No user is logged in."
//            return
//        }
        do {
            showProgressView = true
            let user = try await AuthenticationManager.shared.reAuthentication(email: oldEmail, password: password)
            try await user.sendEmailVerification(beforeUpdatingEmail: newEmail)
            self.message = "Verification email sent to \(newEmail). Please verify your email."
            isCheckingVerification = true
            showProgressView = false

        } catch {
            showProgressView = false
            self.message = "Error: \(error.localizedDescription)"
        }

    }

    func checkEmailVerification() async {
        do {
            let user = try await AuthenticationManager.shared.reAuthentication(email: newEmail, password: password)
            guard let userInfo = AuthenticationManager.shared.getUser() else {
                self.message = "No user is logged in."
                return
            }
            try await userInfo.reload()
            if userInfo.isEmailVerified {
                isCheckingVerification = false

                do {
                    showProgressView = true
                    try await UserManager.shared.changeEmail(userId: user.uid, email: newEmail)
                    showProgressView = false
                    showAlert = true
                    self.message = "Firestore email updated successfully!"
                } catch {
                    showProgressView = false
                    self.message = "Failed to update Firestore: \(error.localizedDescription)"
                }
            } else {
                self.message = "Email is not verified yet. Please try again."
            }

        } catch {
            self.message = "Email is not verified yet. Please try again."
        }
    }
}
