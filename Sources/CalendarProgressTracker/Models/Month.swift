//
//  File.swift
//  
//
//  Created by Erica Stevens on 8/24/22.
//

import Foundation

struct Month: Codable {
    var dates: Range<Date>
    var name: String
    var year: Int
}
