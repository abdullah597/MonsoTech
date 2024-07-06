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
            if let user = UserDefaults.standard.getUser() {
                Constants.oid = user.oid
                self.getUserDetail()
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: String(describing: InitialVC.self)) as! InitialVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    func goToConnectDevice() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: ConnectDeviceVC.self)) as? ConnectDeviceVC {
                Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
            }
        }
    func getUserDetail() {
            APIManager.shared.fetchData(endpoint: .devices, viewController: self) { [weak self](code, result: APIResult<DeviceDetail>) in
                guard let `self` = self else { return }
                switch result {
                case .success(let deviceDetail):
                    DispatchQueue.main.async {
                        if (deviceDetail.devices?.count ?? 0) > 0 {
                            if deviceDetail.devices?.first?.role == "owner" || deviceDetail.devices?.first?.role == "watcher" {
                                Utilities.shared.goToHome(controller: self)
                            } else {
                                self.goToConnectDevice()
                            }
                        } else {
                            self.goToConnectDevice()
                        }
                    }
                case .failure(let error):
                    AlertManager.shared.showAlert(on: self, message: error.localizedDescription, actionText: "Dismiss") {}
                }
            }
        }
}
