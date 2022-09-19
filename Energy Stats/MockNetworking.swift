//
//  MockNetworking.swift
//  Energy Stats
//
//  Created by Alistair Priest on 08/09/2022.
//

import Foundation

class MockNetworking: Network {
    private let throwOnCall: Bool

    init(throwOnCall: Bool = false) {
        self.throwOnCall = throwOnCall
        super.init(credentials: KeychainStore())
    }

    override func fetchReport(variables: [VariableType]) async throws -> ReportResponse {
        if throwOnCall {
            throw NetworkError.unknown
        }

        return ReportResponse(result: [.init(variable: "feedin", data: [.init(index: 14, value: 1.5)])])
    }

    override func fetchBattery() async throws -> BatteryResponse {
        BatteryResponse(errno: 0, result: .init(soc: 56, power: 0.27))
    }

    override func fetchRaw(variables: [VariableType]) async throws -> RawResponse {
        if throwOnCall {
            throw NetworkError.unknown
        }

        let response = try JSONDecoder().decode(RawResponse.self, from: rawData())

        return RawResponse(errno: response.errno, result: response.result.map {
            RawResponse.ReportVariable(variable: $0.variable, data: $0.data.map {
                let thenComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: $0.time)

                let date = Calendar.current.date(bySettingHour: thenComponents.hour ?? 0, minute: thenComponents.minute ?? 0, second: thenComponents.second ?? 0, of: Date())

                return .init(time: date ?? $0.time, value: $0.value)
            })
        })
    }

    private func rawData() throws -> Data {
        guard let url = Bundle(for: type(of: self)).url(forResource: "raw", withExtension: "json") else {
            return Data()
        }

        return try Data(contentsOf: url)
    }

    private func makeData(_ title: String) -> RawResponse.ReportVariable {
        let range = ClosedRange(uncheckedBounds: (1, 30))

        return RawResponse.ReportVariable(variable: title, data: range.map { index -> RawResponse.ReportData in
            RawResponse.ReportData(time: Date().addingTimeInterval(Double(0 - index * 60)), value: Double.random(in: 0...2))
        })
    }
}
