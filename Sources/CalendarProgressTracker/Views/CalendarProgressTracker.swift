import SwiftUI

@available(iOS 14, macOS 11.0, *)
public struct CalendarProgressTracker: View {
    
    public private(set) var date: Date
    private var monthViewModel: MonthViewModel
    
    public init(date: Date = Date(), calendar: Calendar, timeZone: TimeZone) {
        // For now, we can display current month. Eventually, we should show all months from user's first day joining
        self.date = date
        self.monthViewModel = MonthViewModel(for: date, calendar: calendar, timeZone: timeZone)
    }
    
    public var body: some View {
        if let month = monthViewModel.month {
            VStack(alignment: .leading) {
                Text(month.name)
                Text(month.year.description)
            }
        } else {
            EmptyView()
                .onAppear {
                    print("Unable to display month view")
                }
        }
    }
}
