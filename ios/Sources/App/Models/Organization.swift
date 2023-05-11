//
//  Organization.swift
//  
//
//  Created by Ilya Derezovskiy on 08.04.2023.
//

import Fluent
import Vapor

final class Organization: Model, Content {
    static let schema = "organizations"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "urlInfo")
    var urlInfo: String
    
    @Field(key: "urlPay")
    var urlPay: String
    
    @Field(key: "isWorking")
    var isWorking: Bool
    

    init() { }

    init(id: UUID? = nil, name: String, description: String, urlInfo: String, urlPay: String, isWorking: Bool) {
        self.id = id
        self.name = name
        self.description = description
        self.urlInfo = urlInfo
        self.urlPay = urlPay
        self.isWorking = isWorking
    }
}
