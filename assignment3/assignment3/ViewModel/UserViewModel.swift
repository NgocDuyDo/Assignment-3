//
//  UserViewModel.swift
//  assignment3
//
//  Created by Chohwi Park on 29/4/2024.
//

import Foundation
class UserViewModel: ObservableObject {
    @Published var user: User
    @Published var medicationName = ""
    @Published var medicationInstruction = ""
    init() {
        self.user = UserViewModel.loadUser()
    }

    func saveUser() {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "userData")
        }
    }

    static func loadUser() -> User {
        if let userData = UserDefaults.standard.data(forKey: "userData"),
           let decodedUser = try? JSONDecoder().decode(User.self, from: userData) {
            return decodedUser
        }
        return User(name: "", dateOfBirth: Date(), gender: .male, weight: 0, height: 0)
    }
}
