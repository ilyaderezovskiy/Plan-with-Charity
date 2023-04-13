//
//  Organization.swift
//  ios front
//
//  Created by Ilya Derezovskiy on 08.04.2023.
//

import SwiftUI

struct Organization: Identifiable, Codable {
    var id: String = UUID().uuidString
    let name: String
    let description: String
    let urlInfo: String
    let urlPay: String
    let isWorking: Bool
}
