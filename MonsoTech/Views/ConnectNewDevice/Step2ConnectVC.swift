//
//  Step2ConnectVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 13/06/2024.
//

import UIKit

class Step2ConnectVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func back(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
    @IBAction func next(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: Step3ConnectVC.self)) as? Step3ConnectVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
}
