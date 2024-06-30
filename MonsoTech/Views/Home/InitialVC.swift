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
        let authorityURL = URL(string: "\(Constants.kAuthorityHostName)/tfp/\(Constants.kTenantName)/\(Constants.kPolicySignUpOrSignIn)")!
        let authority = try MSALB2CAuthority(url: authorityURL)
        let msalConfiguration = MSALPublicClientApplicationConfig(clientId: Constants.kClientID, redirectUri: Constants.kRedirectUri, authority: authority)
        self.applicationContext = try MSALPublicClientApplication(configuration: msalConfiguration)
    }
    
    @IBAction func withGoogle(_ sender: Any) {
        signIn()
    }
    @IBAction func withMicrosoft(_ sender: Any) {
        
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
    func signIn() {
        let parameters = MSALInteractiveTokenParameters(scopes: ["https://\(Constants.kTenantName).onmicrosoft.com/api/user_impersonation"], webviewParameters: MSALWebviewParameters(authPresentationViewController: self))
        applicationContext?.acquireToken(with: parameters) { (result, error) in
            if let error = error {
                print("Could not acquire token: \(error)")
                return
            }
            
            guard let result = result else {
                print("Could not acquire token: No result returned")
                return
            }
            
            print("Access token is \(result.accessToken)")
        }
    }
}

