import SwiftUI

@available(iOS 16, macOS 11.0, *)
public struct CalendarProgressTracker: View {
    
    public private(set) var date: Date
    private var monthViewModel: MonthViewModel
    
    public init(date: Date = Date(), calendar: Calendar, timeZone: TimeZone) {
        // For now, we can display current month. Eventually, we should show all months from user's first day joining
        self.date = date
        self.monthViewModel = MonthViewModel(for: date, calendar: calendar, timeZone: timeZone)
    }
    
    var weekdays: [GridItem] {
        var items = [GridItem]()
        for _ in Weekday.allCases {
            items.append(GridItem())
        }
        return items
    }
    public var body: some View {
        if let month = monthViewModel.month {
            calendarView(for: month)
        } else {
            EmptyView()
                .onAppear {
                    print("Unable to display month view")
                }
        }
    }
    
    @ViewBuilder func calendarView(for month: Month) -> some View {
        VStack(alignment: .leading)  {
            monthAndYearStackView(for: month)
            dates(for: month)
        }
    }
    
    @ViewBuilder func monthAndYearStackView(for month: Month) -> some View {
        VStack(alignment: .leading)  {
            Text(month.name)
            Text(month.year.description)
        }
        .padding([.leading], 10)
    }
    
    @ViewBuilder func dates(for month: Month) -> some View {
        LazyVGrid(columns: weekdays) {
            ForEach(Weekday.allCases) { weekday in
                Text(weekday.rawValue.capitalized)
            }
            ForEach(month.dates, id: \.date) { day in
                Text(day.isPlaceholder ? "" : "\(day.date)")
                    .background(day.date == month.today.date ? Color.orange : Color.clear)
            }
        }
    }
}
