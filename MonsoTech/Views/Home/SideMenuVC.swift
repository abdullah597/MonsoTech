//
//  SideMenuVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 14/06/2024.
//

import UIKit

class SideMenuVC: UIViewController {

    @IBOutlet weak var blurView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        self.blurView.addGestureRecognizer(tap)
    }
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
}
