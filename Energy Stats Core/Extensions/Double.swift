//
//  Double.swift
//  Energy Stats Core
//
//  Created by Alistair Priest on 02/05/2023.
//

import Foundation

public extension Double {
    func kW(_ places: Int) -> String {
        let divisor = pow(10.0, Double(places))
        let divided = (self * divisor).rounded() / divisor

        return String(format: "%0.\(places)fkW", divided)
    }

    func kWh(_ places: Int) -> String {
        let divisor = pow(10.0, Double(places))
        let divided = (self * divisor).rounded() / divisor

        return String(format: "%0.\(places)fkWh", divided)
    }

    func w() -> String {
        let divided = (self * 1000.0).rounded()

        return String(format: "%0.0fW", divided)
    }

    func rounded(decimalPlaces: Int) -> Double {
        let power = pow(10, Double(decimalPlaces))
        return (self * power).rounded() / power
    }

    func percent() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumIntegerDigits = 1
        formatter.maximumIntegerDigits = 3
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self))!
    }
}