//
//  APIManager.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 23/06/2024.
//

import Foundation
import UIKit
import SystemConfiguration

enum Environment {
    case development
    case staging
    
    var baseURL: String {
        switch self {
        case .development:
            return "https://www.app.monso.tech/"
        case .staging:
            return "https://www.monso.tech/"
        }
    }
}

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case invalidData
    case noInternetConnection
}

enum APIResult<T> {
    case success(T)
    case failure(APIError)
}

class APIManager {
    static let shared = APIManager()
    private var environment: Environment
    
    private init(environment: Environment = .development) {
        self.environment = environment
    }
    
    func setEnvironment(_ environment: Environment) {
        self.environment = environment
    }
    
    func fetchData<T: Decodable>(endpoint: APIEndpoint, viewController: UIViewController, completion: @escaping (APIResult<T>) -> Void) {
        guard let url = endpoint.url(baseURL: environment.baseURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        guard isInternetAvailable() else {
            DispatchQueue.main.async {
                self.showNoInternetAlert(viewController: viewController) {
                    self.fetchData(endpoint: endpoint, viewController: viewController, completion: completion)
                }
            }
            completion(.failure(.noInternetConnection))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
    
    private func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    private func showNoInternetAlert(viewController: UIViewController, retryAction: @escaping () -> Void) {
        let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        let retry = UIAlertAction(title: "Retry", style: .default) { _ in
            retryAction()
        }
        alert.addAction(retry)
        viewController.present(alert, animated: true, completion: nil)
    }
}
