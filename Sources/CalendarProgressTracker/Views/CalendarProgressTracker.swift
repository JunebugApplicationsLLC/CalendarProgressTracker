import SwiftUI
import Combine


@available(iOS 13.0, *)
public class HighlightedDateViewModel: ObservableObject {
    @Published public var days: Days
    public var monthViewModel: MonthViewModel

    public init(monthViewModel: MonthViewModel) {
        self.days = monthViewModel.month?.dates ?? Days(days: [Day]())
        self.monthViewModel = monthViewModel
    }
}

@available(iOS 16, macOS 11.0, *)
public struct CalendarProgressTracker: View {
    @ObservedObject private var monthViewModel: MonthViewModel
    @ObservedObject var highlightedDateViewModel: HighlightedDateViewModel
    var userTappedDateAction: (Day) -> Void
    @State var selectedDay: Day?

    public init(monthViewModel: MonthViewModel, userTappedDateAction: @escaping (Day) -> Void) {
        // For now, we can display current month. Eventually, we should show all months from user's first day joining
        self.monthViewModel = monthViewModel
        self.highlightedDateViewModel = HighlightedDateViewModel(monthViewModel: monthViewModel)
        self.userTappedDateAction = userTappedDateAction
    }
    
    private var weekdays: [GridItem] {
        return Array(repeating: GridItem(), count: Weekday.allCases.count)
    }
    
    var month: Month? {
        return monthViewModel.month
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
    
    var selectedDayShouldBeHighlighted: Bool {
        guard let selectedDay = $selectedDay.wrappedValue else { return false }
        return selectedDay.isHighlighted
    }
    
    func backgroundColor(for day: Day, _ month: Month) -> Color {
        guard !day.isPlaceholder else { return .clear }
        
        if day.date == month.today.date {
            return .mint
        } else if day.isHighlighted {
            return .pink
        }
        return .clear
    }
    
    @ViewBuilder func dates(for month: Month) -> some View {
        GeometryReader { frame in
            LazyVGrid(columns: weekdays) {
                ForEach(Weekday.allCases) { weekday in
                    Text(weekday.rawValue.capitalized)
                        .frame(width: frame.size.width / 7)
                }
                ForEach(month.dates.observableDays, id: \.date) { day in
                    Button {
                        userTappedDateAction(day)
                        selectedDay = day
                    } label: {
                        Text(day.isPlaceholder ? "" : "\(day.date)")
                            .frame(width: frame.size.width / 7, height: frame.size.width / 7)
                            .background(backgroundColor(for: day, month))
                            .clipShape(Circle())
                            .foregroundColor(day > month.today ? Color.gray : Color.black)
                    }
                    .disabled(day > month.today)
                }
            }
        }
    }
}
