//
//  ForgotPasswordVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 14/06/2024.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func sendCode(_ sender: Any) {
        
    }
    @IBAction func signup(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: SignupVC.self)) as? SignupVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
    @IBAction func back(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
}
