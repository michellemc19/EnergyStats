//
//  NetworkFacade.swift
//  Energy Stats
//
//  Created by Alistair Priest on 10/10/2022.
//

import Foundation

public class NetworkFacade: Networking {
    private let network: Networking
    private let fakeNetwork: Networking
    private let config: Config

    public init(network: Networking, config: Config) {
        self.network = network
        self.fakeNetwork = DemoNetworking()
        self.config = config
    }

    public func ensureHasToken() async {
        if config.isDemoUser {
            await fakeNetwork.ensureHasToken()
        } else {
            await network.ensureHasToken()
        }
    }

    public func verifyCredentials(username: String, hashedPassword: String) async throws {
        if config.isDemoUser {
            try await fakeNetwork.verifyCredentials(username: username, hashedPassword: hashedPassword)
        } else {
            try await network.verifyCredentials(username: username, hashedPassword: hashedPassword)
        }
    }

    public func fetchReport(deviceID: String, variables: [ReportVariable], queryDate: QueryDate, reportType: ReportType) async throws -> [ReportResponse] {
        if config.isDemoUser {
            return try await fakeNetwork.fetchReport(deviceID: deviceID, variables: variables, queryDate: queryDate, reportType: reportType)
        }

        return try await network.fetchReport(deviceID: deviceID, variables: variables, queryDate: queryDate, reportType: reportType)
    }

    public func fetchBattery(deviceID: String) async throws -> BatteryResponse {
        if config.isDemoUser {
            return try await fakeNetwork.fetchBattery(deviceID: deviceID)
        }

        return try await network.fetchBattery(deviceID: deviceID)
    }

    public func fetchBatterySettings(deviceSN: String) async throws -> BatterySettingsResponse {
        if config.isDemoUser {
            return try await fakeNetwork.fetchBatterySettings(deviceSN: deviceSN)
        }

        return try await network.fetchBatterySettings(deviceSN: deviceSN)
    }

    public func fetchRaw(deviceID: String, variables: [RawVariable], queryDate: QueryDate) async throws -> [RawResponse] {
        if config.isDemoUser {
            return try await fakeNetwork.fetchRaw(deviceID: deviceID, variables: variables, queryDate: queryDate)
        }

        return try await network.fetchRaw(deviceID: deviceID, variables: variables, queryDate: queryDate)
    }

    public func fetchDeviceList() async throws -> PagedDeviceListResponse {
        if config.isDemoUser {
            return try await fakeNetwork.fetchDeviceList()
        }

        return try await network.fetchDeviceList()
    }

    public func fetchAddressBook(deviceID: String) async throws -> AddressBookResponse {
        if config.isDemoUser {
            return try await fakeNetwork.fetchAddressBook(deviceID: deviceID)
        }

        return try await network.fetchAddressBook(deviceID: deviceID)
    }

    public func fetchVariables(deviceID: String) async throws -> [RawVariable] {
        if config.isDemoUser {
            return try await fakeNetwork.fetchVariables(deviceID: deviceID)
        }

        return try await network.fetchVariables(deviceID: deviceID)
    }

    public func fetchEarnings(deviceID: String) async throws -> EarningsResponse {
        if config.isDemoUser {
            return try await fakeNetwork.fetchEarnings(deviceID: deviceID)
        }

        return try await network.fetchEarnings(deviceID: deviceID)
    }
}
