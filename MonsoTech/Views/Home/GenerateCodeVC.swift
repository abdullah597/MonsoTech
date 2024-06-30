//
//  GenerateCodeVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 14/06/2024.
//

import UIKit

class GenerateCodeVC: UIViewController {
    
    @IBOutlet weak var lblCode: UILabel!
    
    var charCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateCode()
    }
    @IBAction func goBack(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
    func generateCode(){
        let endPoint = APIEndpoint.generateCode(charcode: self.charCode ?? "")
        APIManager.shared.fetchData(endpoint: endPoint, viewController: self) { (code, result: APIResult<ResponseCodeGnerate>) in
            switch result {
            case .success(let t):
                print(t)
                DispatchQueue.main.async {
                    self.lblCode.text = "\(t.connectioncode ?? 0)"
                }
                
            case .failure(let aPIError):
                print(aPIError)
            }
        }
    }
}
struct ResponseCodeGnerate: Codable {
    let connectioncode: Int?
}
