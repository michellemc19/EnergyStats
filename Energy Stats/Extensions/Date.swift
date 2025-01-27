//
//  Date.swift
//  Energy Stats
//
//  Created by Alistair Priest on 20/09/2022.
//

import Foundation

extension Date {
    func militaryTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:00"
        return formatter.string(from: self)
    }

    static func yesterday() -> Date {
        Calendar.current.date(byAdding: .day, value: -1, to: .now)!
    }
}

extension DateFormatter {
    static var dayHour: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MMM HH:00"
        return formatter
    }()

    static var dayMonth: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter
    }()

    static var monthYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, YYYY"
        return formatter
    }()
}
