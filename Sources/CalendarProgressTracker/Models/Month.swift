//
//  File.swift
//  
//
//  Created by Erica Stevens on 8/24/22.
//

import Foundation

@available(iOS 13.0, *)
public struct Month {
    public var dates: Days
    public var weeks: Int
    public var name: String
    public var year: Int
    public var today: Day
    
    public static func month(for date: Date = Date(), calendar: Calendar, timeZone: TimeZone) -> Month? {
        let viewModel = MonthViewModel(for: date, calendar: calendar, timeZone: timeZone)
        
        guard let name = viewModel.month?.name,
              let dates = viewModel.month?.dates,
              let year = viewModel.month?.year,
              let weeks = viewModel.month?.weeks,
              let today = viewModel.month?.today
         else {
            return nil
        }
        
        let month = Month(dates: dates, weeks: weeks, name: name, year: year, today: today)
        return month
    }
}
