//
//  Config.swift
//  Energy Stats
//
//  Created by Alistair Priest on 06/09/2022.
//

import Foundation

class Config {
    static var shared: Config {
        Config()
    }

    @UserDefaultsStoredString(key: "minSOC")
    var minSOC: String?

    @UserDefaultsStoredString(key: "batteryCapacity")
    var batteryCapacity: String?

    @UserDefaultsStoredString(key: "deviceID")
    var deviceID: String?

    @UserDefaultsStoredBool(key: "hasBattery")
    var hasBattery: Bool

    @UserDefaultsStoredBool(key: "hasPV")
    var hasPV: Bool
}

@propertyWrapper
struct UserDefaultsStoredString {
    var key: String

    var wrappedValue: String? {
        get {
            UserDefaults.standard.string(forKey: key)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

@propertyWrapper
struct UserDefaultsStoredBool {
    var key: String

    var wrappedValue: Bool {
        get {
            UserDefaults.standard.bool(forKey: key)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}