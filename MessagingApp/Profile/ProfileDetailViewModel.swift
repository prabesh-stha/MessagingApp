//
//  ProfileDetailViewModel.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 11/09/2024.
//

import Foundation
import SwiftUI
import PhotosUI
@MainActor
final class ProfileDetailViewModel: ObservableObject{
    enum Update{
        case name, photo, both, none
    }
    @Published var photoPickerItem: PhotosPickerItem? = nil
    @Published var selectedImage: Image? = nil
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var disableButton: Bool = true
    @Published var selectedOption: Update = .none
    @Published var isNameSelected: Bool = false
    @Published var isImageSelected: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var showProgressView: Bool = false
    @Published var showDeleteAlert: Bool = false
    
    
    private func update(option: Update, userId: String){
        switch(option){
        case .none:
            break
        case .name:
            updateName(userId: userId)
        case .photo:
            updateImage(userId: userId)
        case .both:
            updateBoth(userId: userId)
        }
    }
    
    func deleteUser(userId: String){
        Task{
            do{
                showProgressView = true
                try await UserStorageManager.shared.deleteImage(userId: userId)
                try await UserManager.shared.deleteUser(userId: userId)
                try await AuthenticationManager.shared.delete()
                showProgressView = false
            }catch{
                showProgressView = false
                showAlert = true
                alertMessage = "Failed to delete"
            }
        }
    }
    
    func update(userId: String){
        var option: Update = .none
        if isNameSelected == true && isImageSelected == false{
            option = .name
        }else if isNameSelected == false && isImageSelected == true{
            option = .photo
        }else if isNameSelected == true && isImageSelected == true{
            option = .both
        }else{
            option = .none
        }
        update(option: option, userId: userId)
    }
    
    private func updateBoth(userId: String){
        Task{
            if let photoPickerItem{
                do{
                    showProgressView = true
                    try await UserStorageManager.shared.deleteImage(userId: userId)
                    let url = try await saveImage(item: photoPickerItem, userId: userId).absoluteString
                    try await UserManager.shared.changeBoth(userId: userId, name: name, imageUrl: url)
                    showProgressView = false
                    showAlert = true
                    alertMessage = "Profile detail updated"
                }catch{
                    showProgressView = false
                    showAlert = true
                    alertMessage = "Failed to update details"
                }
            }
        }
    }
    
    private func updateImage(userId: String){
        Task{
            if let photoPickerItem{
                do{
                    showProgressView = true
                    try await UserStorageManager.shared.deleteImage(userId: userId)
                    let url = try await saveImage(item: photoPickerItem, userId: userId).absoluteString
                    try await UserManager.shared.changeImageUrl(userId: userId, imageUrl: url)
                    showProgressView = false
                    showAlert = true
                    alertMessage = "Profile picture updated"
                }catch{
                    showProgressView = false
                    showAlert = true
                    alertMessage = "Failed to update picture"
                }
            }
            
        }
    }
    
    private func saveImage(item: PhotosPickerItem, userId: String) async throws -> URL{
        guard let data = try await item.loadTransferable(type: Data.self) else { throw URLError(.badURL)}
        let path = try await UserStorageManager.shared.saveImage(userId: userId, data: data)
        let url = try await UserStorageManager.shared.getUrl(path: path)
        return url
    }
    
    private func updateName(userId: String){
        Task{
            do{
                showProgressView = true
                try await UserManager.shared.changeName(userId: userId, name: name)
                showProgressView = false
                showAlert = true
                alertMessage = "Username updated"
            }catch{
                showProgressView = false
                showAlert = true
                alertMessage = "Failed to update username"
            }
        }
    }
    
    func loadInfo(user: UserModel) {
        self.name = user.userName.capitalizeFirstLetters()
        self.email = user.email
        guard let url = URL(string: user.imageUrl) else { return }
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    selectedImage = Image(uiImage: uiImage)
                }
            } catch {
                print("Failed to load image: \(error)")
            }
        }
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
