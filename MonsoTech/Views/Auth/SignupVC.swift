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
        UserManager.shared.createUser(email: email, password: password) { success, error in
            if success {
                print("User created successfully")
            } else {
                print("Sign-up failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
