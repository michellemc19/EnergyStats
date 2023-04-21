//
//  Report.swift
//  Energy Stats
//
//  Created by Alistair Priest on 06/09/2022.
//

import Foundation

struct ReportRequest: Encodable {
    let deviceID: String
    let reportType = "day"
    let variables: [String]
    let queryDate: QueryDate

    internal init(deviceID: String, variables: [ReportVariable], queryDate: QueryDate) {
        self.deviceID = deviceID
        self.variables = variables.map { $0.networkTitle }
        self.queryDate = queryDate
    }
}

public struct QueryDate: Encodable {
    let year: Int
    let month: Int
    let day: Int

    public static func current() -> QueryDate {
        QueryDate(from: Date())
    }

    public init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }

    public init(from date: Date) {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        self.init(year: dateComponents.year!, month: dateComponents.month!, day: dateComponents.day!)
    }

    public func asDate() -> Date? {
        DateComponents(calendar: Calendar.current, year: year, month: month, day: day).date
    }
}

extension QueryDate: Equatable {}

public struct ReportResponse: Decodable, Hashable {
    public let variable: String
    public let data: [ReportData]

    public struct ReportData: Decodable, Hashable {
        public let index: Int
        public let value: Double
    }
}
