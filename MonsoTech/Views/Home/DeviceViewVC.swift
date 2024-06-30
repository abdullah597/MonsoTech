//
//  DeviceViewVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 15/06/2024.
//

import UIKit

class DeviceViewVC: UIViewController {

    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var lblName: UILabel!
    
    var deviceDetail: Device?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.shared.setTopCorners(view: mainView, radius: 30)
        lblProductName.text = deviceDetail?.devicetype ?? "N/A"
        lblName.text = deviceDetail?.name ?? "N/A"
        loader.isHidden = true
    }
    @IBAction func back(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
    @IBAction func disconnect(_ sender: Any) {
        disconnect()
    }
    func disconnect() {
        Utilities.shared.showLoader(loader: loader)
        let body = DisconnectRequestBody(oid: Constants.oid, charcode: self.deviceDetail?.charcode ?? "", disconnect: true)
        APIManager.shared.patchData(endpoint: .registration, requestBody: body, viewController: self) { (code, result: APIResult<String>) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    Utilities.shared.hideLoader(loader: self.loader)
                    Utilities.shared.popViewController(currentViewController: self, animated: true)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    AlertManager.shared.showAlert(on: self, message: "Failed", actionText: "OK") {}
                }
            }
        }
    }
}
