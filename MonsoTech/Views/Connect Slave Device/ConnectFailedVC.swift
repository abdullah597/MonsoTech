//
//  ConnectFailedVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 14/06/2024.
//

import UIKit

class ConnectFailedVC: UIViewController {
    
    var charCode: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func back(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
    @IBAction func send(_ sender: Any) {
        let body = SendFailedBody(oid: Constants.oid, charcode: self.charCode, message: "connection new device failed")
        APIManager.shared.postData(endpoint: .fault, requestBody: body, viewController: self) { (code, result: APIResult<String>) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    if code == 200 {
                        Utilities.shared.goToHome(controller: self)
                    }
                }
                
            case .failure(_):
                DispatchQueue.main.async {
                    AlertManager.shared.showAlert(on: self, message: "Failed", actionText: "Dismiss") {}
                }
            }
        }
    }
}

struct SendFailedBody: Codable {
    let oid, charcode, message: String?
}
