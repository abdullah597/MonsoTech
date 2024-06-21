//
//  TokenManager.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 21/06/2024.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    private init() {}
    
    func getAccessToken(completion: @escaping (String?, Error?) -> Void) {
        let tenantID = "a5d5834c-d7ee-47a0-86b7-9d2f773bd347"
        let clientID = "668b03dc-0873-4043-97ea-7c20dd41fc9b"
        let clientSecret = "RoG8Q~y6F6ku-Nc5gtXiXJtW1OPSQ5.7hO_Tvbw1"
        let scope = "https://graph.microsoft.com/.default"
        let url = URL(string: "https://login.microsoftonline.com/\(tenantID)/oauth2/v2.0/token")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let params = "client_id=\(clientID)&scope=\(scope)&client_secret=\(clientSecret)&grant_type=client_credentials"
        request.httpBody = params.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making request: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "TokenManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(nil, error)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let token = json["access_token"] as? String {
                    completion(token, nil)
                } else {
                    let error = NSError(domain: "TokenManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse access token"])
                    completion(nil, error)
                }
            } catch {
                let parseError = NSError(domain: "TokenManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON response"])
                completion(nil, parseError)
            }
        }
        task.resume()
    }
}

class LoginTokenManager {
    static let shared = LoginTokenManager()
    private init() {}

    func getAccessToken(username: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        let tenantID = "a5d5834c-d7ee-47a0-86b7-9d2f773bd347" // Your Azure AD B2C tenant ID
        let clientID = "668b03dc-0873-4043-97ea-7c20dd41fc9b" // Your Azure AD B2C client ID
        let clientSecret = "RoG8Q~y6F6ku-Nc5gtXiXJtW1OPSQ5.7hO_Tvbw1" // Your Azure AD B2C client secret
        let scope = "https://graph.microsoft.com/.default"
        let authority = "https://monsotech.b2clogin.com/monsotech.onmicrosoft.com"
        let policy = "B2C_1_signup-and-in" // Replace with your Azure AD B2C policy name

        let url = URL(string: "https://login.microsoftonline.com/\(tenantID)/oauth2/v2.0/token")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let verifiedDomain = "monsotech.onmicrosoft.com"
        var email = "\(username.components(separatedBy: "@").first ?? username)@\(verifiedDomain)"
        let params = "client_id=\(clientID)&scope=\(scope)&client_secret=\(clientSecret)&grant_type=password&username=\(email)&password=\(password)"
        request.httpBody = params.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making request: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "LoginTokenManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(nil, error)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let token = json["access_token"] as? String {
                        completion(token, nil)
                    } else if let errorDescription = json["error_description"] as? String {
                        print("Failed to get token: \(errorDescription)")
                        let error = NSError(domain: "LoginTokenManager", code: -1, userInfo: [NSLocalizedDescriptionKey: errorDescription])
                        completion(nil, error)
                    } else {
                        let error = NSError(domain: "LoginTokenManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse access token"])
                        completion(nil, error)
                    }
                }
            } catch {
                let parseError = NSError(domain: "LoginTokenManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON response"])
                completion(nil, parseError)
            }
        }
        task.resume()
    }
}


