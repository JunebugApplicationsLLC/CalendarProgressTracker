//
//  HighlightedDateViewModel.swift
//  
//
//  Created by Erica Stevens on 9/10/22.
//

import SwiftUI

@available(iOS 13.0, *)
public class HighlightedDateViewModel: ObservableObject {
    @Published public var days: Days
    public var monthViewModel: MonthViewModel

    public init(_ calendar: Calendar, _ timeZone: TimeZone) {
        let monthViewModel = MonthViewModel(calendar: calendar, timeZone: timeZone)
        self.days = monthViewModel.month?.dates ?? Days(days: [Day]())
        self.monthViewModel = monthViewModel
    }
}
