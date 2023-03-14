//
//  PowerFlowViewModel.swift
//  Energy Stats
//
//  Created by Alistair Priest on 06/09/2022.
//

import Foundation
import UIKit

class PreciseDateTimeFormatter {
    static func localizedString(from seconds: Int) -> String {
        switch seconds {
        case 0 ..< 60:
            return "\(seconds)s"
        default:
            let minutes = seconds / 60
            let remainder = seconds % 60
            return "\(minutes)m \(remainder)s"
        }
    }
}

class PowerFlowTabViewModel: ObservableObject {
    private let network: Networking
    private var configManager: ConfigManager
    private let timer = CountdownTimer()
    @MainActor @Published private(set) var lastUpdated: String = Date().small()
    @MainActor @Published private(set) var updateState: String = "Updating..."
    @MainActor @Published private(set) var state: State = .unloaded
    private(set) var isLoading = false
    private var totalTicks = 60

    enum State: Equatable {
        case unloaded
        case loaded(HomePowerFlowViewModel)
        case failed(String)
    }

    init(_ network: Networking, configManager: ConfigManager) {
        self.network = network
        self.configManager = configManager

        NotificationCenter.default.addObserver(self, selector: #selector(self.willResignActiveNotification), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didBecomeActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    func startTimer() async {
        await self.timer.start(totalTicks: self.totalTicks) { ticksRemaining in
            Task { @MainActor in
                self.updateState = "Next update in \(PreciseDateTimeFormatter.localizedString(from: ticksRemaining))"
            }
        } onCompletion: {
            Task {
                await self.timerFired()
            }
        }
    }

    func timerFired() async {
        guard self.isLoading == false else { return }

        self.isLoading = true
        defer { isLoading = false }

        await self.loadData()
        await self.startTimer()
    }

    func stopTimer() async {
        await self.timer.stop()
    }

    @MainActor
    func loadData() async {
        do {
            if configManager.currentDevice == nil {
                try await self.configManager.findDevices()
            }

            guard let currentDevice = configManager.currentDevice else {
                self.state = .failed("No devices found. Please logout and try logging in again.")
                return
            }

            if case .failed = self.state {
                state = .unloaded
            }

            await MainActor.run { self.updateState = "Updating..." }
            await self.network.ensureHasToken()

            let raws = try await self.network.fetchRaw(deviceID: currentDevice.deviceID, variables: [.feedinPower, .gridConsumptionPower, .generationPower, .loadsPower, .batChargePower, .batDischargePower])
            let historicalViewModel = HistoricalViewModel(raws: raws)
            let battery = currentDevice.battery != nil ? BatteryViewModel(from: try await self.network.fetchBattery(deviceID: currentDevice.deviceID)) : .noBattery
            let summary = HomePowerFlowViewModel(configManager: configManager,
                                                 solar: historicalViewModel.currentSolarPower,
                                                 battery: battery.chargePower,
                                                 home: historicalViewModel.currentHomeConsumption,
                                                 grid: historicalViewModel.currentGridExport,
                                                 batteryStateOfCharge: battery.chargeLevel,
                                                 hasBattery: battery.hasBattery,
                                                 batteryTemperature: battery.temperature)

            self.state = .loaded(.empty(configManager: self.configManager)) // refreshes the marching ants line speed
            try await Task.sleep(nanoseconds: 1000)
            self.state = .loaded(summary)
            self.calculateTicks(historicalViewModel: historicalViewModel)
            self.updateState = " "
        } catch {
            self.state = .failed(error.localizedDescription)
        }
    }

    func calculateTicks(historicalViewModel: HistoricalViewModel) {
        switch self.configManager.refreshFrequency {
        case .ONE_MINUTE:
            self.totalTicks = 60
        case .FIVE_MINUTES:
            self.totalTicks = 300
        case .AUTO:
            if self.configManager.isDemoUser {
                self.totalTicks = 300
            } else {
                self.totalTicks = Int(300 - (Date().timeIntervalSince(historicalViewModel.lastUpdate)) + 10)
            }
        }
    }

    @objc func didBecomeActiveNotification() {
        Task { await self.timerFired() }
    }

    @objc func willResignActiveNotification() {
        Task { await self.stopTimer() }
    }

    func sleep() async {
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
        } catch {}
    }
}
