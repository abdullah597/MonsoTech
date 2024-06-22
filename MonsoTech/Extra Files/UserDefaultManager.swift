//
//  UserDefaultManager.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 22/06/2024.
//

import Foundation

extension UserDefaults {
    private enum UserDefaultsKeys {
        static let user = "user"
    }
    
    func saveUser(_ user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            self.set(encoded, forKey: UserDefaultsKeys.user)
        }
    }
    
    func getUser() -> User? {
        if let savedUserData = self.data(forKey: UserDefaultsKeys.user) {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(User.self, from: savedUserData) {
                return loadedUser
            }
        }
        return nil
    }
    func clearUser() {
            removeObject(forKey: UserDefaultsKeys.user)
        }
}
