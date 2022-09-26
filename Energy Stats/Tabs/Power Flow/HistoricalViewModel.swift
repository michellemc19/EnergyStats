//
//  ReportViewModel.swift
//  Energy Stats
//
//  Created by Alistair Priest on 06/09/2022.
//

import Foundation

struct HistoricalViewModel: Sendable {
    let currentSolarPower: Double
    let currentGridExport: Double
    let currentHomeConsumption: Double

    init(raws: [RawResponse]) {
        currentSolarPower = raws.currentValue(for: "pvPower")
        currentGridExport = raws.currentValue(for: "feedinPower") - raws.currentValue(for: "gridConsumptionPower")
        currentHomeConsumption = raws.currentValue(for: "loadsPower")
    }
}

extension Array where Element == RawResponse {
    func currentValue(for key: String) -> Double {
        let value: Double

        if let variable = self.first(where: { $0.variable == key }) {
            value = variable.data.last?.value ?? 0.0
        } else {
            value = 0.0
        }

        return value
    }
}

extension Date {
    func currentHour() -> Int? {
        let components = Calendar.current.dateComponents([.hour], from: self)
        return components.hour
    }

    func small() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, HH:mm:ss"
        return formatter.string(from: self)
    }

    func iso8601() -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
}