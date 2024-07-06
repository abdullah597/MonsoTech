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
        enablePushNotifications(token: Constants.fcmToken)
    }
    func enablePushNotifications(token: String) {
        let body = PushNotificationBody(oid: Constants.oid, os: "ios", token: token, pushnotificationsenabled: true)
        APIManager.shared.patchData(endpoint: .pushNotification, requestBody: body, viewController: HomeVC()) { (code, result: APIResult<String>) in
            switch result {
            case .success(let t):
                print(t)
            case .failure(let aPIError):
                print(aPIError)
            }
        }
    }
    @IBAction func connectSlaveDevice(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: ConnectSlaveDeviceVC.self)) as? ConnectSlaveDeviceVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
    @IBAction func connectNewDevice(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: Step1ConnectVC.self)) as? Step1ConnectVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
}
