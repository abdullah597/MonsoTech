//
//  WebViewController.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 23/06/2024.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var urlString: String?
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    
    var text = ""
    var isTerms: Bool? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isTerms == nil {
            lblTitle.text = text
        } else {
            if isTerms ?? true {
                lblTitle.text = "Term of Service"
            } else {
                lblTitle.text = "Privacy Policy"
            }
        }
        
        Utilities.shared.setTopCorners(view: mainView, radius: 30)
        Utilities.shared.setTopCorners(view: webView, radius: 30)
        
        if let urlString = urlString, let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
    @IBAction func back(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
}
