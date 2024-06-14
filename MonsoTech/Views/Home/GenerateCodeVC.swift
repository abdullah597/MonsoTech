//
//  GenerateCodeVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 14/06/2024.
//

import UIKit

class GenerateCodeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func goBack(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
}
