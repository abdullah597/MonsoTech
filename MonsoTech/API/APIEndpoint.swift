//
//  APIEndpoint.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 28/06/2024.
//

import Foundation

enum APIEndpoint {
    case registration
    
    func url(baseURL: String) -> URL? {
        switch self {
        case .registration:
            return URL(string: "\(baseURL)api/registration")
        }
    }
    
    var responseType: Decodable.Type {
        switch self {
        case .registration:
            return RegistrationResponse.self
        }
    }
}

struct RegistrationResponse: Decodable {
    let success: Bool
    let message: String
    // Add other properties based on the API response structure
}
