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
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var errorView: UIView!
    var applicationContext: MSALPublicClientApplication?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func back(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
    
    @IBAction func signup(_ sender: Any) {
        Utilities.shared.showLoader(loader: loader)
        guard let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty else {
            self.errorView.isHidden = false
            self.lblError.text = "Please enter email and password"
            Utilities.shared.hideLoader(loader: loader)
            return
        }
        signUp(email: email, password: password)
    }
    
    @IBAction func login(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: LoginVC.self)) as? LoginVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
    func signUp(email: String, password: String) {
        UserManager.shared.createUser(email: email, password: password) { success, error in
            Utilities.shared.hideLoader(loader: self.loader)
            if success {
                print("User created successfully")
                self.goToHome()
            } else {
                print("Sign-up failed: \(error?.localizedDescription ?? "Unknown error")")
                self.errorView.isHidden = false
                self.lblError.text = "User doesn't exists, Please Signup to continue"
            }
        }
    }
    func goToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: ConnectDeviceVC.self)) as? ConnectDeviceVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
}
