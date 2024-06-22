//
//  SideMenuVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 14/06/2024.
//

import UIKit

protocol SideMenuDelegate: AnyObject {
    func logout()
}

class SideMenuVC: UIViewController {
    weak var delegate: SideMenuDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func logout(_ sender: Any) {
        self.delegate?.logout()
    }
}
