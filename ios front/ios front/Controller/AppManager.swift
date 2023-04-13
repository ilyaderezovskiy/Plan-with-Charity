//
//  AppManager.swift
//  ios front
//
//  Created by Ilya Derezovskiy on 08.04.2023.
//

import Foundation

extension UserDefaults {
    func setLoggedIn(value: Bool, id: String?, name: String, sum: Int) {
        UserDefaults.standard.set(value, forKey: "isLoggedIn")
        UserDefaults.standard.set(id, forKey: "id")
        UserDefaults.standard.set(name, forKey: "username")
        UserDefaults.standard.set(sum, forKey: "sum")
    }

    func isLoggedIn() -> Bool {
        return bool(forKey: "isLoggedIn")
    }

    func getUser() -> User {
        let name: String = UserDefaults.standard.string(forKey: "username") ?? ""
        let id: String? = UserDefaults.standard.string(forKey: "id") ?? ""
        let sum: Int? = UserDefaults.standard.integer(forKey: "sum") ?? 0
        
        NetworkService.shared.getTasks(userID: id!)
        
        return User(id: id!, username: name, sum: sum!)
    }
}
