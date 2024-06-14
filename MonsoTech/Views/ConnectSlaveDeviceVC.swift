//
//  ConnectSlaveDeviceVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 14/06/2024.
//

import UIKit
import DPOTPView

class ConnectSlaveDeviceVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: DPOTPView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func back(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
    @IBAction func connect(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: ConnectFailedVC.self)) as? ConnectFailedVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
}
