//
//  File.swift
//  
//
//  Created by Erica Stevens on 8/26/22.
//

import Foundation

public struct Day: Codable {
    public var name: String
    public var date: Int
    public var monthName: String
    public var isPlaceholder: Bool = false
}
