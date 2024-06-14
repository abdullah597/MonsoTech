//
//  Step1ConnectVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 13/06/2024.
//

import UIKit

class Step1ConnectVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func back(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
    @IBAction func next(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: Step2ConnectVC.self)) as? Step2ConnectVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
}
