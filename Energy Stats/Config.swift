//
//  Config.swift
//  Energy Stats
//
//  Created by Alistair Priest on 06/09/2022.
//

import Foundation
import CryptoKit

class Config {
    static let deviceID = "03274209-486c-4ea3-9c28-159f25ee84cb" // todo: fetch and store on login
    static var shared: Config {
        Config()
    }

    @UserDefaultsStored(key: "minSOC")
    var minSOC: String?

    @UserDefaultsStored(key: "batteryCapacity")
    var batteryCapacity: String?
}

extension String {
    func md5() -> String? {
        let digest = Insecure.MD5.hash(data: data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}

@propertyWrapper
struct UserDefaultsStored {
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
