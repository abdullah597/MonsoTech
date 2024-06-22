//
//  LoginVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 12/06/2024.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var hideShowBtn: UIButton!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.delegate = self
        passwordTF.delegate = self
        self.loader.isHidden = true
    }
    @IBAction func back(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
    @IBAction func hideShowPasswird(_ sender: Any) {
        passwordTF.isSecureTextEntry.toggle()
        let imageName = passwordTF.isSecureTextEntry ? "showPassIcon" : "hidePassIcon"
        hideShowBtn.setImage(UIImage(named: imageName), for: .normal)
    }
    @IBAction func login(_ sender: Any) {
        Utilities.shared.showLoader(loader: loader)
        guard let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty else {
            self.errorView.isHidden = false
            self.lblError.text = "Please enter email and password"
            Utilities.shared.hideLoader(loader: loader)
            return
        }
        LoginTokenManager.shared.getAccessToken(username: email, password: password) { token, error in
            DispatchQueue.main.async {
                Utilities.shared.hideLoader(loader: self.loader)
                if let error = error {
                    print("Login failed \(error.localizedDescription)")
                    self.errorView.isHidden = false
                    self.lblError.text = "User doesn't exists, Please Signup to continue"
                } else if let token = token {
                    print("Login successful, token: \(token)")
                    let user = User(email: email, token: token)
                    UserDefaults.standard.saveUser(user)
                    self.goToHome()
                }
            }
        }
    }
    func goToHome() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: HomeVC.self)) as? HomeVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.errorView.isHidden = true
    }
    @IBAction func signup(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: SignupVC.self)) as? SignupVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
    @IBAction func forgotPassword(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: ForgotPasswordVC.self)) as? ForgotPasswordVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
}
