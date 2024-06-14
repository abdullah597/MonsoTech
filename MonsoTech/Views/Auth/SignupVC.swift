//
//  SignupVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 12/06/2024.
//

import UIKit

class SignupVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func back(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
}
