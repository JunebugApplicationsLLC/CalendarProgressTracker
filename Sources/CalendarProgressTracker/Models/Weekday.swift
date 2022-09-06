//
//  File.swift
//  
//
//  Created by Erica Stevens on 8/25/22.
//

import Foundation

enum Weekday: String, CaseIterable, Identifiable {
    var id: Self { self }
    case sunday = "Sun"
    case monday = "Mon"
    case tuesday = "Tues"
    case wednesday = "Wed"
    case thursday = "Thurs"
    case friday = "Fri"
    case saturday = "Sat"
    
    func nameForDay() -> String {
        switch self {
        case .sunday:
            return "Sun"
        case .monday:
            return "Mon"
        case .tuesday:
            return "Tue"
        case .wednesday:
            return "Wed"
        case .thursday:
            return "Thu"
        case .friday:
            return "Fri"
        case .saturday:
            return "Sat"
        }
    }
}
