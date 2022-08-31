# CalendarProgressTracker

This package provides a monthly calendar view that can be used to track user progress across the days in a given month.

The default `CalendarProgressTracker(calendar: Calendar, timeZone: TimeZone)` takes in the `calendar` and `timeZone` environment values to display the current month for a given time zone.

Example usage:

```
import SwiftUI
import CalendarProgressTracker

struct ContentView: View {
    @Environment(\.calendar) private var calendar
    @Environment(\.timeZone) private var timeZone
    
    var body: some View {
      CalendarProgressTracker(calendar: calendar, timeZone: timeZone)
    }
}
```
[To-Do: Insert Simulator Screenshot here.]

Future releases will include:
- the ability to conditionally highlight dates based on business logic
- the ability to pass in color schemes, font styles and other customization attributes (e.g. leading/trailing Month Label)
- widgets for home screen and watchOS integration?
- ability to tap date to display detail popover (e.g. stats for given date)

This package differs from Apple's `MultiDatePicker` in that it does not allow users to select to highlight the days in the calendar, but the logic rests with the app to determine which days should be highlighted. 

This package is great to use when you'd like to track and reflect daily user patterns. 

Want to contribute? Feel free to open a PR against main.

Having problems using the package, or want to suggest new features? Please open an issue.
