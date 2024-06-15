//
//  DeviceViewVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 15/06/2024.
//

import UIKit

class DeviceViewVC: UIViewController {

    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.shared.setTopCorners(view: mainView, radius: 30)
    }
    @IBAction func back(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
}
