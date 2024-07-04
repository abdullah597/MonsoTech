//
//  Device.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 29/06/2024.
//

import Foundation

// MARK: - Welcome
struct DeviceDetail: Codable {
    let devicecount: Int?
    let devices: [Device]?
}

// MARK: - Device
struct Device: Codable {
    let charcode, role: String?
    let name: String?
    let devicetype: String?
    let trigercount, trigercountunread: Int?
    var watchers: [Watcher]?
    let settings: [Setting]?
}

// MARK: - Setting
struct Setting: Codable {
    let label, type, variable: String?
    let value: Bool
}

// MARK: - Watcher
struct Watcher: Codable {
    let name, oid: String?
}
