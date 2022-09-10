//
//  File.swift
//  
//
//  Created by Erica Stevens on 8/26/22.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
public class Days: ObservableObject {
    
    @Published public var observableDays: [Day]
    
    public init(days: [Day]) {
        self.observableDays = days
    }
}

@available(iOS 13.0, *)
public struct Day: Codable, Hashable, Identifiable {
    public var id: String { "\(monthName) \(name) \(date)" }
    public var name: String
    public var date: Int
    public var monthName: String
    public var isPlaceholder: Bool = false
    public var isHighlighted: Bool = false
    
    public mutating func should(highlightDay: Bool) {
        self.isHighlighted = highlightDay
    }
    
    public init(name: String, date: Int, monthName: String, isPlaceholder: Bool = false, isHighlighted: Bool = false) {
        self.name = name
        self.date = date
        self.monthName = monthName
        self.isPlaceholder = isPlaceholder
        self.isHighlighted = isHighlighted
    }
    
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(ObjectIdentifier(self))
//    }
}

@available(iOS 13.0, *)
extension Day: Comparable {
    public static func == (lhs: Day, rhs: Day) -> Bool {
//        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
        return lhs.date == rhs.date
    }
    
    public static func < (lhs: Day, rhs: Day) -> Bool {
        return lhs.date < rhs.date
    }
}
