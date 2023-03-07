//
//  SettingsTabViewModel.swift
//  Energy Stats
//
//  Created by Alistair Priest on 05/03/2023.
//

import SwiftUI

class SettingsTabViewModel: ObservableObject {
    @Published var showColouredLines: Bool {
        didSet {
            config.showColouredLines = showColouredLines
        }
    }

    @Published var batteryCapacity: String {
        didSet {
            config.batteryCapacity = batteryCapacity
        }
    }

    @Published var showBatteryTemperature: Bool {
        didSet {
            config.showBatteryTemperature = showBatteryTemperature
        }
    }

    @Published var refreshFrequency: RefreshFrequency {
        didSet {
            config.refreshFrequency = refreshFrequency
        }
    }

    @Published var decimalPlaces: Int = 2 {
        didSet {
            config.decimalPlaces = decimalPlaces
        }
    }

    @Published var showSunnyBackground: Bool {
        didSet {
            config.showSunnyBackground = showSunnyBackground
        }
    }

    private var config: ConfigManaging
    private let userManager: UserManager

    init(userManager: UserManager, config: ConfigManaging) {
        self.userManager = userManager
        self.config = config
        showColouredLines = config.showColouredLines
        batteryCapacity = String(describing: config.batteryCapacity)
        showBatteryTemperature = config.showBatteryTemperature
        refreshFrequency = config.refreshFrequency
        decimalPlaces = config.decimalPlaces
        showSunnyBackground = config.showSunnyBackground
    }

    var minSOC: Double { config.minSOC }
    var username: String { userManager.getUsername() ?? "" }

    @MainActor
    func logout() {
        userManager.logout()
    }
}
