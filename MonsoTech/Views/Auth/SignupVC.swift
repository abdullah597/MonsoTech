//
//  SignupVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 12/06/2024.
//

import UIKit
import MSAL

class SignupVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var applicationContext: MSALPublicClientApplication?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try self.initMSAL()
        } catch {
            print("Unable to create MSAL application \(error)")
        }
    }
    @IBAction func back(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
    @IBAction func signup(_ sender: Any) {
        guard let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty else {
            print("invalid things!..")
            return
        }
        signUp(email: email, password: password)
    }
    func signUp(email: String, password: String) {
        let signUpUrl = "https://ehtishambadargmail.b2clogin.com/ehtishambadargmail.onmicrosoft.com/B2X_1_signupsignin1/oauth2/v2.0/token"
        
        var request = URLRequest(url: URL(string: signUpUrl)!)
        request.httpMethod = "POST"
        let params = [
            "client_id": Constants.clientId,
            "scope": "https://ehtishambadargmail.onmicrosoft.com/\(Constants.clientId)/.default",
            "grant_type": "password",
            "username": "ehtisham.badar@gmail.com",
            "password": "Hashtag55@",
            "redirect_uri": Constants.redirectURL
        ]
        
        request.httpBody = params.percentEncoded()
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Sign-up error: \(error)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            // Handle the response
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Sign-up response: \(json)")
                    DispatchQueue.main.async {
                        print("success")
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        task.resume()
    }
    func initMSAL() throws {
        guard let authorityURL = URL(string: Constants.authorityURL) else {
            throw NSError(domain: "MSAL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid authority URL"])
        }
        
        let authority = try MSALAADAuthority(url: authorityURL)
        let msalConfig = MSALPublicClientApplicationConfig(clientId: Constants.clientId, redirectUri: Constants.redirectURL, authority: authority)
        self.applicationContext = try MSALPublicClientApplication(configuration: msalConfig)
    }
}
extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
