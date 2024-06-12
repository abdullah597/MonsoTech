//
//  InitialVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 11/06/2024.
//

import UIKit

class InitialVC: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.shared.setTopCorners(view: mainView, radius: 30)
    }
    
    @IBAction func withGoogle(_ sender: Any) {
        
    }
    @IBAction func withMicrosoft(_ sender: Any) {
        
    }
    @IBAction func withMonsotech(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: LoginVC.self)) as? LoginVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
}

