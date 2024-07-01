//
//  InitialVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 11/06/2024.
//

import UIKit
import MSAL

class InitialVC: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    var applicationContext: MSALPublicClientApplication?
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.shared.setTopCorners(view: mainView, radius: 30)
        do {
            try self.initMSAL()
        } catch {
            print("Unable to create MSAL PublicClientApplication: \(error)")
        }
    }
    
    func initMSAL() throws {
        guard let authorityURL = URL(string: "https://monsotech.b2clogin.com/tfp/monsotech.onmicrosoft.com/\(Constants.kPolicySignUpOrSignIn)") else {
            return
        }
        
        let authority = try MSALAuthority(url: authorityURL)
        let pcaConfig = MSALPublicClientApplicationConfig(clientId: Constants.clientId, redirectUri: Constants.kRedirectUri, authority: authority)
        pcaConfig.knownAuthorities = [authority]
        pcaConfig.bypassRedirectURIValidation = false  // Disable authority validation
        self.applicationContext = try MSALPublicClientApplication(configuration: pcaConfig)
    }
    
    @IBAction func withGoogle(_ sender: Any) {
        acquireToken(forProvider: "google")
    }
    @IBAction func withMicrosoft(_ sender: Any) {
        acquireToken(forProvider: "microsoft")
    }
    @IBAction func withMonsotech(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: LoginVC.self)) as? LoginVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
    @IBAction func signup(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: SignupVC.self)) as? SignupVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
    func acquireToken(forProvider provider: String) {
        guard let applicationContext = self.applicationContext else { return }
        
        let parameters = MSALInteractiveTokenParameters(scopes: ["https://monsotech.onmicrosoft.com/api/read"], webviewParameters: MSALWebviewParameters(parentViewController: self))
        
        // Configure the login hint or extra query parameters based on the provider if needed
        if provider == "google" {
            parameters.extraQueryParameters = ["login_hint": "Google"]
        } else if provider == "microsoft" {
            parameters.extraQueryParameters = ["login_hint": "Microsoft"]
        }
        
        applicationContext.acquireToken(with: parameters) { (result, error) in
            if let error = error {
                print("Error acquiring token: \(error)")
                return
            }
            
            guard let result = result else {
                print("No result returned")
                return
            }
            
            print("Result: \(result)")
            print("Access token is \(result.accessToken ?? "nil")")
        }
    }
}

