//
//  File.swift
//  
//
//  Created by Erica Stevens on 8/24/22.
//

import Foundation

@available(iOS 13.0, *)
class MonthViewModel: ObservableObject {
    @Published var month: Month?
    private var calendar: Calendar
    private var timeZone: TimeZone
    
    init(for date: Date, calendar: Calendar, timeZone: TimeZone) {
        
        self.calendar = calendar
        self.timeZone = timeZone
        
        let monthDates = MonthViewModel.monthDates(from: calendar, date: date, timeZone: timeZone)
        let monthName = MonthViewModel.monthName(from: calendar, date: date)
        let year = MonthViewModel.year(for: calendar, date: date)
        let weeksInMonth = MonthViewModel.weeksInMonth(for: calendar, date: date)
        self.month = Month(dates: monthDates, weeks: weeksInMonth, name: monthName, year: year)
    }
    
    static func monthStartDate(from components: DateComponents, calendar: Calendar) -> Int {
        guard let currentMonthDate = calendar.date(from: components),
              let monthStartDate = calendar.dateComponents([.day, .year, .month], from: currentMonthDate).day else { return 1 }
        return monthStartDate
    }
    
    static func monthEndDate(from components: DateComponents, calendar: Calendar) -> Int {
        var components = components
        components.month = (components.month ?? 0) + 1
        components.hour = (components.hour ?? 0) - 1
        guard let currentMonthDate = calendar.date(from: components),
              let monthEndDate = calendar.dateComponents([.day, .year, .month], from: currentMonthDate).day else { return 31 }
        return monthEndDate
    }
    
    static func year(for calendar: Calendar, date: Date) -> Int {
        return calendar.dateComponents([.year, .month], from: date).year ?? 0
    }
    
    static func weeksInMonth(for calendar: Calendar, date: Date) -> Range<Int> {
//        let daysInMonth =
        return 1..<4
    }
    
    static func monthName(from calendar: Calendar, date: Date) -> String {
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let foo = Calendar.current.date(from: components) else { return "Failed" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let dateString = dateFormatter.string(from: foo)
        let dateComponents = dateString.components(separatedBy: " ")
        let monthName = dateComponents.first!
        return monthName
    }
    
    static func monthDates(from calendar: Calendar, date: Date, timeZone: TimeZone) -> Range<Int> {
        let start = monthStartDate(from: calendar.dateComponents([.year, .month], from: date), calendar: calendar)
        
        var end = monthEndDate(from: calendar.dateComponents([.year, .month], from: date), calendar: calendar)
        end += 1 // increment by 1 because we can't pass a closed range to ForEach without Int conforming to Identifiable
        return start..<end
    }
 }
