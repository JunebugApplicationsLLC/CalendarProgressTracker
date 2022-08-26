//
//  File.swift
//  
//
//  Created by Erica Stevens on 8/24/22.
//

import Foundation

struct Month: Codable {
    var dates: [Day]
    var weeks: Int
    var name: String
    var year: Int
}

struct Day: Codable, Identifiable {
    var id: UUID { UUID() }
    var name: String
    var date: Int
    var monthName: String
    var isPlaceholder: Bool = false
}
