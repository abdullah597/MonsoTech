//
//  Step3ConnectVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 13/06/2024.
//

import UIKit

class Step3ConnectVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func next(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: Step4ConnectVC.self)) as? Step4ConnectVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
}
