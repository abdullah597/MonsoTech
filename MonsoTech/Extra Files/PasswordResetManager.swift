//
//  PasswordResetManager.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 06/07/2024.
//

import UIKit

class PasswordResetManager {
    
    static let shared = PasswordResetManager()
    
    private init() {}
    
    func sendPasswordResetEmail(to email: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: "https://your-backend-endpoint/reset-password") else {
            let error = NSError(domain: "PasswordResetManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid backend URL"])
            completion(false, error)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonPayload: [String: Any] = ["email": email]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonPayload) else {
            let error = NSError(domain: "PasswordResetManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create JSON payload"])
            completion(false, error)
            return
        }
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let error = NSError(domain: "PasswordResetManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])
                completion(false, error)
                return
            }
            
            completion(true, nil)
        }
        
        task.resume()
    }
}
