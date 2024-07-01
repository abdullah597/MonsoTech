//
//  APIEndpoint.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 28/06/2024.
//

import Foundation

enum APIEndpoint {
    case registration
    case devices
    case generateCode(charcode: String)
    case fault
    case triggers(charcode: String)
    case pushNotification
    
    func url(baseURL: String) -> URL? {
        switch self {
        case .registration:
            return URL(string: "\(baseURL)api/registration")
        case .devices:
            return URL(string: "\(baseURL)api/devices/\(Constants.oid)")
        case .generateCode(let code):
            return URL(string: "\(baseURL)api/generatecode/\(Constants.oid)/\(code)")
        case .fault:
            return URL(string: "\(baseURL)api/fault")
        case .triggers(let charcode):
            return URL(string: "\(baseURL)api/triggers/\(charcode)")
        case .pushNotification:
            return URL(string: "\(baseURL)api/pushnotification")
        }
    }
}
