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
    case monsoFault
    
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
        case .monsoFault:
            return URL(string: "\(baseURL)fault/")
        }
    }
}
