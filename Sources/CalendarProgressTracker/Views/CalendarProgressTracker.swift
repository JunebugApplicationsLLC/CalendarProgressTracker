import SwiftUI

@available(iOS 16, macOS 11.0, *)
public struct CalendarProgressTracker: View {
    public private(set) var date: Date
    @ObservedObject private var monthViewModel: MonthViewModel
    var highlightDayAction: () -> Bool
    var userTappedDateAction: (Day) -> Void
    
    @State var shouldHighlightDay: (day: Day, shouldHighlight: Bool)? = nil

    public init(date: Date = Date(), calendar: Calendar, timeZone: TimeZone, highlightDayAction: @escaping () -> Bool, userTappedDateAction: @escaping (Day) -> Void) {
        // For now, we can display current month. Eventually, we should show all months from user's first day joining
        let viewModel = MonthViewModel(for: date, calendar: calendar, timeZone: timeZone)
        self.date = date
        self.monthViewModel = viewModel
        self.userTappedDateAction = userTappedDateAction
        self.highlightDayAction = highlightDayAction
    }
    
    private var weekdays: [GridItem] {
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
//                        if let highlightDayAction = highlightDayAction  {
                        let highlightInfo = (day, highlightDayAction())
                        shouldHighlightDay = highlightInfo
//                        }
                    } label: {
                        Text(day.isPlaceholder ? "" : "\(day.date)")
                            .frame(width: frame.size.width / 7, height: frame.size.width / 7)
                            .background(shouldHighlightDay?.day == day ? shouldHighlightDay?.shouldHighlight ?? false ? Color.pink : Color.clear : Color.clear)
                            .background(day.date == month.today.date ? Color.mint : Color.clear)
                            .clipShape(Circle())
                            .foregroundColor(.black)
                    }
                    
                }
            }
        }
    }
}
