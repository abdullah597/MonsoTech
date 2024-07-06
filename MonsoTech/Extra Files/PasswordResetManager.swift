//
//  PasswordResetManager.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 06/07/2024.
//

import UIKit
import MSAL

class PasswordResetManager {
    
    static let shared = PasswordResetManager()
    
    private init() {}
    
    func resetPassword(completion: @escaping (Bool, Error?) -> Void) {
        // Define the authority URL for the password reset policy
        let authorityURLString = "https://monsotech.b2clogin.com/tfp/monsotech.onmicrosoft.com/B2C_1_PasswordReset"
        
        // Ensure the authority URL is valid
        guard let authorityURL = URL(string: authorityURLString) else {
            let error = NSError(domain: "PasswordResetManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid authority URL"])
            completion(false, error)
            return
        }
        
        // Create the MSAL authority
        guard let authority = try? MSALAuthority(url: authorityURL) else {
            let error = NSError(domain: "PasswordResetManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create MSALAuthority"])
            completion(false, error)
            return
        }
        
        // Create the MSAL configuration
        let msalConfig = MSALPublicClientApplicationConfig(clientId: "668b03dc-0873-4043-97ea-7c20dd41fc9b", redirectUri: nil, authority: authority)
        
        // Initialize the MSAL public client application
        guard let application = try? MSALPublicClientApplication(configuration: msalConfig) else {
            let error = NSError(domain: "PasswordResetManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create MSALPublicClientApplication"])
            completion(false, error)
            return
        }
        
        // Set up the web view parameters for the interactive token request
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            let error = NSError(domain: "PasswordResetManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No root view controller found"])
            completion(false, error)
            return
        }
        
        let webParameters = MSALWebviewParameters(authPresentationViewController: rootViewController)
        let interactiveParameters = MSALInteractiveTokenParameters(scopes: ["https://monsotech.onmicrosoft.com/api/read"], webviewParameters: webParameters)
        
        // Acquire the token to initiate the password reset flow
        application.acquireToken(with: interactiveParameters) { (result, error) in
            if let error = error {
                // Handle the error case
                if let msalError = error as NSError?, msalError.domain == MSALErrorDomain, msalError.code == MSALError.interactionRequired.rawValue {
                    print("User cancelled the password reset flow.")
                    completion(false, nil)
                    return
                }
                print("Error acquiring token: \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            guard let result = result else {
                // Handle the case where no result was received
                let error = NSError(domain: "PasswordResetManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No result received from token acquisition"])
                completion(false, error)
                return
            }
            
            // Password reset successful
            print("Password reset successful. Token: \(result.accessToken)")
            completion(true, nil)
        }
    }
}
