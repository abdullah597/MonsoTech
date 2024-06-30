//
//  ConnectYourDeviceVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 14/06/2024.
//

import UIKit
import DPOTPView

class ConnectYourDeviceVC: UIViewController {
    
    @IBOutlet weak var digitTF: DPOTPView!
    @IBOutlet weak var characterStringTF: DPOTPView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        characterStringTF.keyboardType = .alphabet
        loader.isHidden = true
    }
    @IBAction func back(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
    @IBAction func nextStep(_ sender: Any) {
        if characterStringTF.text == "" {
            AlertManager.shared.showAlert(on: self, message: "Enter 5 character string", actionText: "OK") {}
        } else if digitTF.text == "" {
            AlertManager.shared.showAlert(on: self, message: "Enter 3 digit number", actionText: "OK") {}
        } else {
            let combinedText = "\(characterStringTF.text ?? "")\(digitTF.text ?? "")"
            if combinedText == "AAAAA123" || combinedText == "AAAAB678" {
                self.connectDevice()
//                self.goToHome()
            } else {
                AlertManager.shared.showAlert(on: self, message: "Wrong", actionText: "Dismiss") {}
            }
        }
    }
    func goToHome() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: HomeVC.self)) as? HomeVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
    func connectDevice() {
        Utilities.shared.showLoader(loader: loader)
        
        // Constructing the request body
        let connectionRequest = RequestBodyDevice(
            oid: Constants.oid,
            role: "owner",
            charcode: characterStringTF.text ?? "",
            digitcode: Int(digitTF.text ?? "") ?? 0
        )
        
        // Calling APIManager to post data
        APIManager.shared.postData(endpoint: .registration, requestBody: connectionRequest, viewController: self) { (code, result: APIResult<[String: String]>) in
            DispatchQueue.main.async {
                Utilities.shared.hideLoader(loader: self.loader)
                
                switch result {
                case .success(_):
                    if code == 200 || code == 201 {
                        self.goToHome()
                    } else if code == 400 {
                        AlertManager.shared.showAlert(on: self, message: "Device Already Paired", actionText: "Go to Devices") {
                            self.goToHome()
                        }
                    }
                    
                case .failure(let error):
                    // Handle failure
                    print("API Error: \(error)")
                }
            }
        }
    }


}
struct RequestBodyDevice: Codable {
    let oid, role, charcode: String?
    let digitcode: Int?
}
struct ResultResponse: Codable {
    let result: String?
}
