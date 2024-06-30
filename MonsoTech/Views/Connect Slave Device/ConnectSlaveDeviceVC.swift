//
//  ConnectSlaveDeviceVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 14/06/2024.
//

import UIKit
import DPOTPView

class ConnectSlaveDeviceVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: DPOTPView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.isHidden = true
    }
    @IBAction func back(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
    @IBAction func connect(_ sender: Any) {
        connectDevice()
    }
    func goToHome() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: HomeVC.self)) as? HomeVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
    func goToConnectFailed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: ConnectFailedVC.self)) as? ConnectFailedVC {
            secondViewController.charCode = textField.text ?? ""
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
    func connectDevice(){
        Utilities.shared.showLoader(loader: loader)
        let body = SlaveDeviceBody(oid: Constants.oid, role: "watcher", connectioncode: textField.text ?? "")
        APIManager.shared.postData(endpoint: .registration, requestBody: body, viewController: self) { (code, result: APIResult<ResultResponse>) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    Utilities.shared.hideLoader(loader: self.loader)
                    if code == 500 || code == 400 {
                        self.goToConnectFailed()
                    }
                    if code == 200 {
                        self.goToHome()
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    AlertManager.shared.showAlert(on: self, message: "Failed", actionText: "OK") {}
                }
            }
        }
    }
}

struct SlaveDeviceBody: Codable {
    let oid, role, connectioncode: String?
}
