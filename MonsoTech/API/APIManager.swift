//
//  APIManager.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 23/06/2024.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case invalidData
}

enum APIResult<T> {
    case success(T)
    case failure(APIError)
}

class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    func fetchData<T: Decodable>(from url: URL, completion: @escaping (APIResult<T>) -> Void) {
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
}
