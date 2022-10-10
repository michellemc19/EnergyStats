//
//  NetworkFacade.swift
//  Energy Stats
//
//  Created by Alistair Priest on 10/10/2022.
//

import Foundation

class NetworkFacade: Networking {
    private let network: Networking
    private let fakeNetwork: Networking
    private let config: Config

    init(network: Networking, config: Config) {
        self.network = network
        self.fakeNetwork = MockNetworking()
        self.config = config
    }

    func ensureHasToken() async {
        if config.isDemoUser {
            await fakeNetwork.ensureHasToken()
        }

        await network.ensureHasToken()
    }

    func verifyCredentials(username: String, hashedPassword: String) async throws {
        if config.isDemoUser {
            try await fakeNetwork.verifyCredentials(username: username, hashedPassword: hashedPassword)
        }

        try await network.verifyCredentials(username: username, hashedPassword: hashedPassword)
    }

    func fetchReport(variables: [VariableType]) async throws -> [ReportResponse] {
        if config.isDemoUser {
            return try await fakeNetwork.fetchReport(variables: variables)
        }

        return try await network.fetchReport(variables: variables)
    }

    func fetchBattery() async throws -> BatteryResponse {
        if config.isDemoUser {
            return try await fakeNetwork.fetchBattery()
        }

        return try await network.fetchBattery()
    }

    func fetchRaw(variables: [VariableType]) async throws -> [RawResponse] {
        if config.isDemoUser {
            return try await fakeNetwork.fetchRaw(variables: variables)
        }

        return try await network.fetchRaw(variables: variables)
    }

    func fetchDeviceList() async throws -> PagedDeviceListResponse {
        if config.isDemoUser {
            return try await fakeNetwork.fetchDeviceList()
        }

        return try await network.fetchDeviceList()
    }
}
