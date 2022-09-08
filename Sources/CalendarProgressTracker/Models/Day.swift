//
//  File.swift
//  
//
//  Created by Erica Stevens on 8/26/22.
//

import Foundation

public struct Day: Codable, Hashable, Identifiable {
    public var id: String { "\(monthName) \(name) \(date)" }
    public var name: String
    public var date: Int
    public var monthName: String
    public var isPlaceholder: Bool = false
}

extension Day: Comparable {
    public static func == (lhs: Day, rhs: Day) -> Bool {
        return lhs.date == rhs.date
    }
    
    public static func < (lhs: Day, rhs: Day) -> Bool {
        return lhs.date < rhs.date
    }
}
