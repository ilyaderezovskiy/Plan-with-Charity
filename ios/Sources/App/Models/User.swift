//
//  User.swift
//  
//
//  Created by Ilya Derezovskiy on 02.04.2023.
//

import Fluent
import Vapor

final class User: Model {
    static let schema = "users"
    
    @ID(key: "id")
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password_hash")
    var passwordHash: String
    
    @Field(key: "sum")
    var sum: Int
    
    @Field(key: "passed")
    var passed: Int
    
    final class Public: Content {
        var id: UUID?
        var username: String
        var sum: Int
        var passed: Int
        
        init(id: UUID? = nil, username: String, sum: Int, passed: Int) {
            self.id = id
            self.username = username
            self.sum = sum
            self.passed = passed
        }
    }
}

// Получение публичной информации о пользователе (имя и накопленная сумма)
extension User {
    func asPublic() -> User.Public {
        User.Public(id: id, username: username, sum: sum, passed: passed)
    }
}

// Авторизация пользователя
extension User: ModelAuthenticatable {
    static let usernameKey = \User.$username
    static let passwordHashKey = \User.$passwordHash

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}
