//
//  TaskModel.swift
//  ios front
//
//  Created by Ilya Derezovskiy on 06.04.2023.
//

import SwiftUI

struct TaskModel: Identifiable, Codable {
    var id: String = UUID().uuidString
    let userID: String
    let title: String
    let time: String
    let cost: Int
    let description: String
    let category: String
    let isDone: Bool
    var isOverdue: Bool
}

func getSampleDate(offset: Int) -> Date {
    var calendar = Calendar.current
    calendar.locale =  Locale(identifier: "ru")
    
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    
    return date ?? Date()
}

