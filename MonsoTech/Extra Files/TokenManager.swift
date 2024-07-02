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
    
    func getAccessToken(completion: @escaping (String?, String?, Error?) -> Void) {
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
                completion(nil,nil, error)
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "TokenManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(nil,nil, error)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let token = json["access_token"] as? String {
                    if let oid = self.getObjectId(from: token) {
                        completion(token, oid, nil)
                    } else {
                        let error = NSError(domain: "LoginTokenManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse object ID"])
                        completion(nil, nil, error)
                    }
                } else {
                    let error = NSError(domain: "TokenManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse access token"])
                    completion(nil,nil, error)
                }
            } catch {
                let parseError = NSError(domain: "TokenManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON response"])
                completion(nil,nil, parseError)
            }
        }
        task.resume()
    }
    private func getObjectId(from idToken: String) -> String? {
        let segments = idToken.split(separator: ".")
        guard segments.count == 3 else {
            return nil
        }
        
        var payloadSegment = String(segments[1])
        
        // Add padding if necessary
        while payloadSegment.count % 4 != 0 {
            payloadSegment.append("=")
        }
        
        guard let payloadData = Data(base64Encoded: payloadSegment) else {
            return nil
        }
        
        do {
            if let payloadJson = try JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any],
               let oid = payloadJson["oid"] as? String {
                return oid
            }
        } catch {
            print("Error parsing ID token: \(error.localizedDescription)")
        }
        
        return nil
    }
}

import Foundation

class LoginTokenManager {
    static let shared = LoginTokenManager()
    private init() {}
    
    func getAccessToken(username: String, password: String, completion: @escaping (String?, String?, Error?) -> Void) {
        let tenantID = "a5d5834c-d7ee-47a0-86b7-9d2f773bd347" // Your Azure AD B2C tenant ID
        let clientID = "668b03dc-0873-4043-97ea-7c20dd41fc9b" // Your Azure AD B2C client ID
        let clientSecret = "RoG8Q~y6F6ku-Nc5gtXiXJtW1OPSQ5.7hO_Tvbw1" // Your Azure AD B2C client secret
        let scope = "https://graph.microsoft.com/.default openid profile"
        
        let url = URL(string: "https://login.microsoftonline.com/\(tenantID)/oauth2/v2.0/token")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let verifiedDomain = "monsotech.onmicrosoft.com"
        let email = "\(username.components(separatedBy: "@").first ?? username)@\(verifiedDomain)"
        let params = "client_id=\(clientID)&scope=\(scope)&client_secret=\(clientSecret)&grant_type=password&username=\(email)&password=\(password)"
        request.httpBody = params.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making request: \(error.localizedDescription)")
                completion(nil, nil, error)
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "LoginTokenManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(nil, nil, error)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let token = json["access_token"] as? String, let idToken = json["id_token"] as? String {
                        // Decode the ID token to extract the object ID
                        if let oid = self.getObjectId(from: idToken) {
                            completion(token, oid, nil)
                        } else {
                            let error = NSError(domain: "LoginTokenManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse object ID"])
                            completion(nil, nil, error)
                        }
                    } else if let errorDescription = json["error_description"] as? String {
                        print("Failed to get token: \(errorDescription)")
                        let error = NSError(domain: "LoginTokenManager", code: -1, userInfo: [NSLocalizedDescriptionKey: errorDescription])
                        completion(nil, nil, error)
                    } else {
                        let error = NSError(domain: "LoginTokenManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse access token"])
                        completion(nil, nil, error)
                    }
                }
            } catch {
                let parseError = NSError(domain: "LoginTokenManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON response"])
                completion(nil, nil, parseError)
            }
        }
        task.resume()
    }
    
    private func getObjectId(from idToken: String) -> String? {
        let segments = idToken.split(separator: ".")
        guard segments.count == 3 else {
            return nil
        }
        
        var payloadSegment = String(segments[1])
        
        // Add padding if necessary
        while payloadSegment.count % 4 != 0 {
            payloadSegment.append("=")
        }
        
        guard let payloadData = Data(base64Encoded: payloadSegment) else {
            return nil
        }
        
        do {
            if let payloadJson = try JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any],
               let oid = payloadJson["oid"] as? String {
                return oid
            }
        } catch {
            print("Error parsing ID token: \(error.localizedDescription)")
        }
        
        return nil
    }

}



