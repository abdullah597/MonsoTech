//
//  LaunchScreenViewController.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 22/06/2024.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            if let _ = UserDefaults.standard.getUser() {
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: String(describing: HomeVC.self)) as! HomeVC
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: String(describing: InitialVC.self)) as! InitialVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
}
