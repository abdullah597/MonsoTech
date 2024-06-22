//
//  Utilities.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 12/06/2024.
//

import Foundation
import UIKit

class Utilities {
    static let shared = Utilities()
    
    private init() {}
    
    func setTopCorners(view: UIView, radius: CGFloat) {
        view.layer.cornerRadius = radius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    func pushViewController(currentViewController: UIViewController, toViewController: UIViewController, animated: Bool) {
        if let navigationController = currentViewController.navigationController {
            navigationController.pushViewController(toViewController, animated: animated)
        } else {
            print("The current view controller is not embedded in a navigation controller.")
        }
    }
    func popViewController(currentViewController: UIViewController, animated: Bool) {
        currentViewController.navigationController?.popViewController(animated: true)
    }
    func showLoader(loader: UIActivityIndicatorView) {
        loader.isHidden = false
        loader.startAnimating()
    }
    func hideLoader(loader: UIActivityIndicatorView) {
        loader.isHidden = true
        loader.stopAnimating()
    }
}
class AlertManager {
    static let shared = AlertManager()
    private init() {}
    
    func showAlert(on viewController: UIViewController, message: String, actionText: String, completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: actionText, style: .default) { _ in
            completion()
        }
        
        alertController.addAction(action)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
