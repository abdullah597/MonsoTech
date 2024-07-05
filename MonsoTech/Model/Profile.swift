//
//  Profile.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 01/07/2024.
//

import Foundation

// MARK: - Welcome
struct ProfileDevice: Codable {
    let triggercount, triggerunread: Int?
    let triggers: [Trigger]?
}

// MARK: - Trigger
struct Trigger: Codable {
    let starttime, startdate: String?
    let resolved, viewed: Bool?
    let endtime, enddate: String?
    let duration: String?
}

