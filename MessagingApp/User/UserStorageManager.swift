//
//  UserStorageManager.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import Foundation
import FirebaseStorage

final class UserStorageManager{
    static let shared = UserStorageManager()
    private init() {}
    
    private let storageReference = Storage.storage().reference()
    
    private func userReference(userId: String) -> StorageReference {
        storageReference.child("users").child(userId)
    }
    
    func saveImage(userId: String, data: Data) async throws -> String{
        let metaData = StorageMetadata()
        metaData.contentType = "jpeg/png"
        let data = try await userReference(userId: userId).putDataAsync(data, metadata: metaData)
        
        guard let path = data.path else{ throw URLError(.badURL)}
        return path
    }
    
   private func getPath(path: String) -> StorageReference{
        Storage.storage().reference(withPath: path)
    }
    
    func getUrl(path: String) async throws -> URL{
        try await getPath(path: path).downloadURL()
    }
}
