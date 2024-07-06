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
        let authorityURL = "https://monsotech.b2clogin.com/tfp/monsotechxw.onmicrosoft.com/B2C_1_PasswordReset"
        guard let authority = try? MSALAuthority(url: URL(string: authorityURL)!) else {
            let error = NSError(domain: "PasswordResetManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid authority URL"])
            completion(false, error)
            return
        }
        
        let msalConfig = MSALPublicClientApplicationConfig(clientId: "<YOUR_CLIENT_ID>", redirectUri: nil, authority: authority)
        guard let application = try? MSALPublicClientApplication(configuration: msalConfig) else {
            let error = NSError(domain: "PasswordResetManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create MSALPublicClientApplication"])
            completion(false, error)
            return
        }
        
        let webParameters = MSALWebviewParameters(authPresentationViewController: UIApplication.shared.windows.first!.rootViewController!)
        let interactiveParameters = MSALInteractiveTokenParameters(scopes: ["https://monsotech.onmicrosoft.com/api/read"], webviewParameters: webParameters)
        
        application.acquireToken(with: interactiveParameters) { (result, error) in
            if let error = error {
                if let msalError = error as NSError?, msalError.domain == MSALErrorDomain {
                    if msalError.code == MSALError.interactionRequired.rawValue {
                        print("User cancelled the password reset flow.")
                        completion(false, nil)
                        return
                    }
                }
                print("Error acquiring token: \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            guard let result = result else {
                let error = NSError(domain: "PasswordResetManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No result received from token acquisition"])
                completion(false, error)
                return
            }
            
            print("Password reset successful. Token: \(result.accessToken)")
            completion(true, nil)
        }
    }
}
