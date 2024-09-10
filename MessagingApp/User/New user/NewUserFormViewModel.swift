//
//  NewUserFormViewModel.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import Foundation
import SwiftUI
import PhotosUI
import FirebaseAuth

@MainActor
final class NewUserFormViewModel: ObservableObject{
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var userName: String = ""
    @Published var photoPickerItem: PhotosPickerItem? = nil
    @Published var selectedImage: Image? = nil
    @Published var isValid: Bool = true
    
    //Errors
    @Published var emailError: String? = nil
    @Published var passwordError: String? = nil
    @Published var nameError: String? = nil
    @Published var imageError: String? = nil
    
    
    @Published var showProgressView: Bool = false
    @Published var showAlert: Bool = false
    @Published var message: String = ""
    
    func validate(){
        if !FormValidation.isValidEmail(email){
            emailError = "Please enter valid email"
            isValid = false
        }
        
        if !FormValidation.validatePassword(password){
            passwordError = "Password must be at least 8 characters long, contain at least one letter, and at least one number."
            isValid = false
        }else{
            passwordError = nil
        }
        
        if !FormValidation.validateFullName(userName){
            nameError = "Enter full name"
            isValid = false
        }else{
            nameError = nil
        }
        
        if photoPickerItem == nil {
            imageError = "Select a picture"
            isValid = false
        }else{
            imageError = nil
        }
    }
    
    func userImageUrl(item: PhotosPickerItem, userId: String) async throws -> URL{
        guard let data = try await item.loadTransferable(type: Data.self) else {
            throw URLError(.badURL)
        }
       let path = try await UserStorageManager.shared.saveImage(userId: userId, data: data)
        let url = try await UserStorageManager.shared.getUrl(path: path)
        return url
    }
    
    func checkExisitingEmail(){
        Task{
            do{
                let emailExists = try await UserManager.shared.checkEmail(email: email.lowercased())
                if emailExists{
                    emailError = "Email already exists. Please enter a different email."
                    isValid = false
                }else{
                    emailError = nil
                    isValid = true
                }
            }catch{
                print("Error while fetching")
            }
        }
        
    }
    
    func signUp() async throws -> Bool{
        var showHome: Bool = false
        showProgressView = true
        validate()
        if isValid{
                do{
                    if let photoPickerItem{
                        let auth = try await Auth.auth().createUser(withEmail: email, password: password)
                        let imageUrl = try await userImageUrl(item: photoPickerItem, userId: auth.user.uid).absoluteString
                        let user = UserModel(userId: auth.user.uid, userName: userName, email: email, imageUrl: imageUrl)
                        try await UserManager.shared.createNewUser(user: user)
                        showProgressView = false
                        showHome = true
                    }

                }catch{
                    showProgressView = false
                    message = "Error while signing up"
                    showAlert = true
                    showHome = false
                }
        }else{
            showProgressView = false
        }
        return showHome
        
}
    
    func loadImage(){
        Task{
            do{
                if let photoPickerItem{
                    if let loadedItem = try await photoPickerItem.loadTransferable(type: Image.self){
                        selectedImage = loadedItem
                    }
                }
            }catch{
                print("Couldn't load image")
            }
        }
    }
}
