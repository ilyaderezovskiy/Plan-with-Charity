//
//  User.swift
//  ios front
//
//  Created by Ilya Derezovskiy on 06.04.2023.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String = UUID().uuidString
    let username: String
    var sum: Int
}
