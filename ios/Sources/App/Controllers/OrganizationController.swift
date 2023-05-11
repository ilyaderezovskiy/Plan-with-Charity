//
//  OrganizationController.swift
//  
//
//  Created by Ilya Derezovskiy on 08.04.2023.
//

import Fluent
import Vapor

struct OrganizationController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let organizations = routes.grouped("organizations")
        organizations.get(use: index)
        
        organizations.post(use: create)
        organizations.delete(":id", use: delete)
        organizations.put(":id", use: update)
    }

    // Получение всех благотворительных организаций
    func index(req: Request) async throws -> [Organization] {
        try await Organization.query(on: req.db).all()
    }
    
    // Создание новой благотворительной организации
    func create(req: Request) async throws -> Organization {
        let organization = try req.content.decode(Organization.self)
        try await organization.save(on: req.db)
        return organization
    }
    
    // Обновление информации о благотворительной организации по id
    func update(req: Request) async throws -> Organization {
        guard let organization = try await Organization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedOrganization = try req.content.decode(Organization.self)

        organization.name = updatedOrganization.name
        organization.description = updatedOrganization.description
        organization.urlInfo = updatedOrganization.urlInfo
        organization.urlPay = updatedOrganization.urlPay
        organization.isWorking = updatedOrganization.isWorking
        
        try await organization.save(on: req.db)
        
        return organization
    }

    // Удаление благотворительной организации
    func delete(req: Request) async throws -> HTTPStatus {
        guard let organization = try await Organization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await organization.delete(on: req.db)
        return .noContent
    }
}
