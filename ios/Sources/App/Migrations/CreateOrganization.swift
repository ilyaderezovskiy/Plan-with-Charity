//
//  CreateOrganization.swift
//  
//
//  Created by Ilya Derezovskiy on 08.04.2023.
//

import Fluent
import Vapor

struct CreateOrganization: AsyncMigration {
    
    // Создание базы данных
    func prepare(on database: Database) async throws {
        try await database.schema("organizations")
            .id()
            .field("name", .string, .required)
            .unique(on: "name")
            .field("description", .string, .required)
            .field("urlInfo", .string, .required)
            .field("urlPay", .string, .required)
            .field("isWorking", .bool, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("organizations").delete()
    }
}
