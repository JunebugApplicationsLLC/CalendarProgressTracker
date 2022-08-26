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
        
        let components = calendar.dateComponents([.year, .month], from: date)
        let monthName = MonthViewModel.monthName(from: calendar, date: date)
        let year = MonthViewModel.year(for: calendar, date: date)
        let monthDates = MonthViewModel.monthDates(from: calendar, components: components, timeZone: timeZone, monthName: monthName)
        let daysAndWeeksInMonth = MonthViewModel.daysAndweeks(in: monthDates)
        self.month = Month(dates: daysAndWeeksInMonth.days, weeks: daysAndWeeksInMonth.weeks, name: monthName, year: year)
    }
    
    static func year(for calendar: Calendar, date: Date) -> Int {
        return calendar.dateComponents([.year, .month], from: date).year ?? 0
    }
    
    static private func daysAndweeks(in month: [Day]) -> (weeks: Int, days: [Day]) {
        guard let firstDayInMonth = month.first else { return (4, []) }
        
        let placeholderCount = findDifferenceFromSunday(to: firstDayInMonth.name)
        
        var placeholderDays: [Day] = []
        
        for _ in 0..<placeholderCount {
            placeholderDays.append((Day(name: "", date: 0, monthName: "", isPlaceholder: true)))
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
            if monthStartDay == weekdays[position].rawValue {
                break
            }
        }
        
        let previousMonthDaysCount = previousMonthDays.count - 1
        
        return previousMonthDaysCount
    }
    
    static func monthName(from calendar: Calendar, date: Date) -> String {
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let date = Calendar.current.date(from: components) else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let dateString = dateFormatter.string(from: date)
        let dateComponents = dateString.components(separatedBy: " ")
        let monthName = dateComponents.first!
        return monthName
    }
    
    static func monthDates(from calendar: Calendar, components: DateComponents, timeZone: TimeZone, monthName: String) -> [Day] {
        guard let monthStartDate = calendar.date(from: components) else {
            return []
        }
        // Pull start of month date value (ex: 1 for August 1st)
        var startOfMonthDateComponents = monthStartDate.description.components(separatedBy: " ")
        let monthStartInfoWithDate = startOfMonthDateComponents.removeFirst()
        var monthStartDateInfoComponents = monthStartInfoWithDate.components(separatedBy: "-")
        let monthStartDateValue = monthStartDateInfoComponents.remove(at: monthStartDateInfoComponents.count - 1)
        
        var endDateComponents = components
        endDateComponents.month = (endDateComponents.month ?? 0) + 1
        endDateComponents.hour = (endDateComponents.hour ?? 0) - 1
        
        guard let monthEndDate = calendar.date(from: endDateComponents) else {
            return []
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMMM-d HH:mm:ss 'UTC'"
        let endOfMonth = dateFormatter.string(from: monthEndDate)

        // Pull start of month date value (ex: 31 for August 31st)
        var endOfMonthDateComponents = endOfMonth.description.components(separatedBy: " ")
        let monthEndInfoWithDate = endOfMonthDateComponents.removeFirst()
        var monthEndDateInfoComponents = monthEndInfoWithDate.components(separatedBy: "-")
        let monthEndDateValue = monthEndDateInfoComponents.remove(at: monthEndDateInfoComponents.count - 1)
        
        guard let monthStart = Int(monthStartDateValue),
              let monthEnd = Int(monthEndDateValue) else {
            return []
        }
        var monthDates = [Date]()
        
        var iterableComponents = components
        
        for _ in monthStart...monthEnd {
            guard let date = calendar.date(from: iterableComponents) else { return [] }
            monthDates.append(date)
            iterableComponents.day = (iterableComponents.day ?? 1) + 1
        }
        
        var days = [Day]()
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy-MMMM-E HH:mm:ss 'UTC'"

        for date in monthDates {
            var dateComponents = date.description.components(separatedBy: " ")
            let dateInfo = dateComponents.removeFirst()
            var dateInfoComponents = dateInfo.components(separatedBy: "-")
            let dateValue = dateInfoComponents.remove(at: dateInfoComponents.count - 1)
            
            let formattedDate = dayFormatter.string(from: date)
            var dayComponents = formattedDate.components(separatedBy: " ")
            let dayInfo = dayComponents.removeFirst()
            var dayInfoComponents = dayInfo.components(separatedBy: "-")
            let dayName = dayInfoComponents.remove(at: dayInfoComponents.count - 1)
            
            guard let dateValue = Int(dateValue) else { return [] }
            
            let day = Day(name: dayName, date: dateValue, monthName: monthName)
            days.append(day)
        }
        return days
    }
 }
