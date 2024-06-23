//
//  ConnectYourDeviceVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 14/06/2024.
//

import UIKit
import DPOTPView

class ConnectYourDeviceVC: UIViewController {

    @IBOutlet weak var digitTF: DPOTPView!
    @IBOutlet weak var characterStringTF: DPOTPView!
    override func viewDidLoad() {
        super.viewDidLoad()
        characterStringTF.keyboardType = .alphabet
    }
    @IBAction func back(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
    @IBAction func nextStep(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: HomeVC.self)) as? HomeVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
}
