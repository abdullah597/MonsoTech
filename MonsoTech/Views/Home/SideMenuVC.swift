//
//  SideMenuVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 14/06/2024.
//

import UIKit

protocol SideMenuDelegate: AnyObject {
    func logout()
    func siteClick()
    func orderClick()
    func licenseClick()
    func versionClick()
}

class SideMenuVC: UIViewController {
    weak var delegate: SideMenuDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func logout(_ sender: Any) {
        self.delegate?.logout()
    }
    @IBAction func site(_ sender: Any) {
        self.delegate?.siteClick()
    }
    @IBAction func orde(_ sender: Any) {
        self.delegate?.orderClick()
    }
    @IBAction func license(_ sender: Any) {
        self.delegate?.licenseClick()
    }
    @IBAction func version(_ sender: Any) {
        self.delegate?.versionClick()
    }
}
