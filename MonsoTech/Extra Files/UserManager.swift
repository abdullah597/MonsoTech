//
//  UserManager.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 21/06/2024.
//

import Foundation

class UserManager {
    static let shared = UserManager()
    private init() {}

    func createUser(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        TokenManager.shared.getAccessToken { token, error in
            guard let token = token, error == nil else {
                completion(false, error)
                return
            }

            let url = URL(string: "https://graph.microsoft.com/v1.0/users")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            let verifiedDomain = "monsotech.onmicrosoft.com" // Replace with your verified domain
            let userPrincipalName = "\(email.components(separatedBy: "@").first ?? email)@\(verifiedDomain)"

            let userPayload: [String: Any] = [
                "accountEnabled": true,
                "displayName": email,
                "mailNickname": email.components(separatedBy: "@").first ?? email,
                "userPrincipalName": userPrincipalName,
                "passwordProfile": [
                    "forceChangePasswordNextSignIn": false,
                    "password": password
                ]
            ]

            let jsonData = try? JSONSerialization.data(withJSONObject: userPayload)
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Request error: \(error.localizedDescription)")
                    completion(false, error)
                    return
                }

                guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                    print("No response or data")
                    completion(false, NSError(domain: "UserManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No response or data"]))
                    return
                }

                if httpResponse.statusCode == 201 {
                    completion(true, nil)
                } else {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let errorMessage = json["error"] as? [String: Any],
                       let message = errorMessage["message"] as? String {
                        print("API error: \(message)")
                        completion(false, NSError(domain: "UserManager", code: -1, userInfo: [NSLocalizedDescriptionKey: message]))
                    } else {
                        print("Unexpected API response: \(httpResponse.statusCode)")
                        completion(false, NSError(domain: "UserManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected API response"]))
                    }
                }
            }
            task.resume()
        }
    }
}
