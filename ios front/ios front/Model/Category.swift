//
//  Category.swift
//  ios front
//
//  Created by Ilya Derezovskiy on 06.04.2023.
//

import SwiftUI

enum Category: String, CaseIterable {
    case general = "General"
    case bug = "Bug"
    case idea = "Idea"
    case modifiers = "Modifiers"
    case challenge = "Challenge"
    case coding = "Coding"
    
    var color: Color {
        switch self {
        case .general:
            return .blue
        case .bug:
            return .purple
        case .idea:
            return .mint
        case .modifiers:
            return .orange
        case .challenge:
            return .yellow
        case .coding:
            return .brown
        }
    }
}

