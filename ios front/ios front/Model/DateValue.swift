//
//  DateValue.swift
//  ios front
//
//  Created by Ilya Derezovskiy on 06.04.2023.
//

import SwiftUI

struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
