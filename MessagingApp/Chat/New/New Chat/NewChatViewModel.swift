//
//  NewChatViewModel.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 10/09/2024.
//

import Foundation

@MainActor
final class NewChatViewModel: ObservableObject {
    @Published var users: [UserModel] = []
    @Published var searchText = ""
    @Published var filteredUsers: [UserModel] = []    


    func getUsers(userId: String) {
        Task {
            do {
                self.users = try await UserManager.shared.getAllUser().filter { $0.userId != userId }
            } catch {
                print("Couldn't get users")
            }
        }
    }

    func heuristicSearch(query: String, in users: [UserModel]) -> [UserModel] {
            let queryWords = query.lowercased().trimmingCharacters(in: .whitespaces).split(separator: " ")
            var results: [(user: UserModel, score: Int)] = []
            
            for user in users {
                let nameComponents = user.userName.lowercased().split(separator: " ")
                var score = 0
                
                for queryWord in queryWords {
                    if nameComponents.contains(queryWord) {
                        score += 3
                    } else if nameComponents.contains(where: { $0.starts(with: queryWord) }) {
                        score += 2
                    } else if nameComponents.contains(where: { $0.contains(queryWord) }) {
                        score += 1
                    }
                }
                
                if score > 0 {
                    results.append((user: user, score: score))
                }
            }
            
            return results.sorted { $0.score > $1.score }.map { $0.user }
        }


}
