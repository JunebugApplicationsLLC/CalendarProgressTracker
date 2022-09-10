//
//  File.swift
//  
//
//  Created by Erica Stevens on 8/24/22.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
public class MonthViewModel: ObservableObject {
    @Published var month: Month?
    private var calendar: Calendar
    private var timeZone: TimeZone
    

    public init(for date: Date = Date(), calendar: Calendar, timeZone: TimeZone) {
        self.calendar = calendar
        self.timeZone = timeZone

        let components = calendar.dateComponents([.year, .month], from: date)
        let monthName = MonthViewModel.monthName(date: date)
        let year = MonthViewModel.year(for: calendar, date: date)
        let monthDates = MonthViewModel.monthDates(from: calendar, components: components, timeZone: timeZone, monthName: monthName)
        let daysAndWeeksInMonth = MonthViewModel.daysAndweeks(in: monthDates)
        let today = MonthViewModel.day(from: date, monthName: monthName)
        self.month = Month(dates: Days(days: daysAndWeeksInMonth.days), weeks: daysAndWeeksInMonth.weeks, name: monthName, year: year, today: today)
    }

    static private var dayFormatter: DateFormatter {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy-MMMM-E HH:mm:ss 'UTC'"
        return dayFormatter
    }

    static private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMMM-d HH:mm:ss 'UTC'"
        return dateFormatter
    }

    /// Extract date value (ex: 1 for Aug 1)
    static private func dateValue(for date: Date) -> Int {
        let formattedDate = MonthViewModel.dateFormatter.string(from: date)
        var dateComponents = formattedDate.components(separatedBy: " ")
        let dateInfo = dateComponents.removeFirst()
        var dateInfoComponents = dateInfo.components(separatedBy: "-")
        let dateValue = dateInfoComponents.remove(at: dateInfoComponents.count - 1)
        
        guard let dateValue = Int(dateValue) else { return 0 }
        return dateValue
    }

    /// Extract day name for date (ex: Wed for Aug 31, 2022)
    static private func dayNameValue(for date: Date) -> String {
        let formattedDate = MonthViewModel.dayFormatter.string(from: date)
        var dayComponents = formattedDate.components(separatedBy: " ")
        let dayInfo = dayComponents.removeFirst()
        var dayInfoComponents = dayInfo.components(separatedBy: "-")
        let dayName = dayInfoComponents.remove(at: dayInfoComponents.count - 1)
        return dayName
    }

    static private func monthName(date: Date) -> String {
        let formattedDate = MonthViewModel.dayFormatter.string(from: date)
        var dayComponents = formattedDate.components(separatedBy: " ")
        let monthInfo = dayComponents.removeFirst()
        var monthInfoComponents = monthInfo.components(separatedBy: "-")
        let monthName = monthInfoComponents.remove(at: monthInfoComponents.count - 2)
        return monthName
    }

    static private func year(for calendar: Calendar, date: Date) -> Int {
        return calendar.dateComponents([.year, .month], from: date).year ?? 0
    }

    static private func day(from date: Date, monthName: String) -> Day {
        let dateValue = dateValue(for: date)
        let dayName = dayNameValue(for: date)
        let day = Day(name: dayName, date: dateValue, monthName: monthName)
        return day
    }

    static private func daysAndweeks(in month: [Day]) -> (weeks: Int, days: [Day]) {
        guard let firstDayInMonth = month.first else { return (4, []) }
        
        let placeholderCount = findDifferenceFromSunday(to: firstDayInMonth.name)
        var placeholderDays: [Day] = []
        
        for _ in 0..<placeholderCount {
            placeholderDays.append((Day(name: "", date: Int.random(in: Int.min...0), monthName: "", isPlaceholder: true)))
        }

        var datesWithPlaceholders = month
        datesWithPlaceholders.insert(contentsOf: placeholderDays, at: 0)
        var numberOfWeeksInMonth = datesWithPlaceholders.count / Weekday.allCases.count

        if datesWithPlaceholders.count % 7 != 0 {
            numberOfWeeksInMonth += 1
        }
        return (numberOfWeeksInMonth, datesWithPlaceholders)
    }
    
    static private func findDifferenceFromSunday(to monthStartDay: String) -> Int {
        let weekdays = Weekday.allCases
        var previousMonthDays = [Weekday]()
        
        for position in 0..<weekdays.count  {
            previousMonthDays.append(weekdays[position])
            if monthStartDay == weekdays[position].nameForDay() {
                break
            }
        }
        
        let previousMonthDaysCount = previousMonthDays.count - 1
        return previousMonthDaysCount
    }

    static private func monthDates(from calendar: Calendar, components: DateComponents, timeZone: TimeZone, monthName: String) -> [Day] {
        guard let monthStartDate = calendar.date(from: components) else { return [] }

        let monthStartDateValue = MonthViewModel.dateValue(for: monthStartDate)
        
        var endDateComponents = components
        endDateComponents.month = (endDateComponents.month ?? 0) + 1
        endDateComponents.hour = (endDateComponents.hour ?? 0) - 1
        
        guard let monthEndDate = calendar.date(from: endDateComponents) else { return [] }

        let monthEndDateValue = MonthViewModel.dateValue(for: monthEndDate)
        var monthDates = [Date]()
        var iterableComponents = components
        
        for _ in monthStartDateValue...monthEndDateValue {
            guard let date = calendar.date(from: iterableComponents) else { return [] }
            monthDates.append(date)
            iterableComponents.day = (iterableComponents.day ?? 1) + 1
        }
        
        var days = [Day]()
        
        for date in monthDates {
            let day = MonthViewModel.day(from: date, monthName: monthName)
            days.append(day)
        }
        return days
    }
 }
