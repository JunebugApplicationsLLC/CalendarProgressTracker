import SwiftUI

@available(iOS 16, macOS 11.0, *)
public struct CalendarProgressTracker: View {
    public private(set) var date: Date
    @ObservedObject private var monthViewModel: MonthViewModel
    var userTappedDateAction: (Day) -> Void

    public init(date: Date = Date(), calendar: Calendar, timeZone: TimeZone, userTappedDateAction: @escaping (Day) -> Void) {
        // For now, we can display current month. Eventually, we should show all months from user's first day joining
        self.date = date
        self.monthViewModel = MonthViewModel(for: date, calendar: calendar, timeZone: timeZone)
        self.userTappedDateAction = userTappedDateAction
    }
    
    var weekdays: [GridItem] {
        return Array(repeating: GridItem(), count: Weekday.allCases.count)
    }

    public var body: some View {
        GeometryReader { frame in
            if let month = monthViewModel.month {
                calendarView(for: month)
                    .padding([.leading, .trailing], frame.size.width * 0.05)
            } else {
                EmptyView()
                    .onAppear {
                        print("Unable to display month view")
                    }
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
                .font(.largeTitle)
            Text(month.year.description)
                .font(.title2)
        }
        .padding([.leading], 10)
    }
    
    @ViewBuilder func dates(for month: Month) -> some View {
        GeometryReader { frame in
            LazyVGrid(columns: weekdays) {
                ForEach(Weekday.allCases) { weekday in
                    Text(weekday.rawValue.capitalized)
                        .frame(width: frame.size.width / 7)
                }
                ForEach(month.dates, id: \.date) { day in
                    Button {
                        userTappedDateAction(day)
                    } label: {
                        Text(day.isPlaceholder ? "" : "\(day.date)")
                            .frame(width: frame.size.width / 7, height: frame.size.width / 7)
                            .background(day.date == month.today.date ? Color.mint : Color.clear)
                            .clipShape(Circle())
                            .foregroundColor(.black)
                    }
                    
                }
            }
        }
    }
}
