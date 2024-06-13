//
//  ConnectDeviceVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 12/06/2024.
//

import UIKit

class ConnectDeviceVC: UIViewController {

    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.shared.setTopCorners(view: mainView, radius: 30)
    }
    @IBAction func connectSlaveDevice(_ sender: Any) {
        
    }
    @IBAction func connectNewDevice(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: Step1ConnectVC.self)) as? Step1ConnectVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
}
