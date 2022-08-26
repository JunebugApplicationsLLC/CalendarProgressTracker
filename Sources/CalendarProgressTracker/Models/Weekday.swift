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
}
