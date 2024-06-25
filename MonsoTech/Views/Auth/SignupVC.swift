//
//  SignupVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 12/06/2024.
//

import UIKit
import MSAL

class SignupVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var atleastLcUcICon: UIImageView!
    @IBOutlet weak var atleast1Icon: UIImageView!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var min8Icon: UIImageView!
    @IBOutlet weak var agreeIcon: UIImageView!
    @IBOutlet weak var hideShowBtn: UIButton!
    
    @IBOutlet weak var signupBtn: UIButton!
    var applicationContext: MSALPublicClientApplication?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.isHidden = true
        passwordTF.delegate = self
        updateIcons(for: "")
        signupBtn.isEnabled = false
        setupTermsLabel()
        hideShowBtn.setImage(UIImage(named: "hidePassIcon"), for: .normal)
    }
    @IBAction func back(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
    
    @IBAction func signup(_ sender: Any) {
//        Utilities.shared.showLoader(loader: loader)
//        guard let email = emailTF.text, !email.isEmpty,
//              let password = passwordTF.text, !password.isEmpty else {
//            self.errorView.isHidden = false
//            self.lblError.text = "Please enter email and password"
//            Utilities.shared.hideLoader(loader: loader)
//            return
//        }
//        signUp(email: email, password: password)
        goToHome()
    }
    
    @IBAction func hideShowPassword(_ sender: Any) {
        passwordTF.isSecureTextEntry.toggle()
        let imageName = passwordTF.isSecureTextEntry ? "hidePassIcon" : "showPassIcon"
        hideShowBtn.setImage(UIImage(named: imageName), for: .normal)
        hideShowBtn.tintColor = UIColor.hexStringToUIColor(hex: "9CA3AF")
    }
    @IBAction func login(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: LoginVC.self)) as? LoginVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
    @IBAction func agree(_ sender: Any) {
        
    }
    func signUp(email: String, password: String) {
        UserManager.shared.createUser(email: email, password: password) { success, error in
            DispatchQueue.main.async {
                Utilities.shared.hideLoader(loader: self.loader)
                if success {
                    print("User created successfully")
                    self.goToHome()
                } else {
                    print("Sign-up failed: \(error?.localizedDescription ?? "Unknown error")")
                    self.errorView.isHidden = false
                    self.lblError.text = "User already exists, Please Login to continue"
                }
            }
        }
    }
    func goToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: ConnectDeviceVC.self)) as? ConnectDeviceVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
}

extension SignupVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newText = (text as NSString).replacingCharacters(in: range, with: string)
        updateIcons(for: newText)
        
        return true
    }
    
    func updateIcons(for password: String) {
        let min8Characters = password.count >= 8
        let containsNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        let containsLetter = password.rangeOfCharacter(from: .letters) != nil
        
        min8Icon.image = UIImage(named: min8Characters ? "tick" : "cross")
        atleast1Icon.image = UIImage(named: containsNumber ? "tick" : "cross")
        atleastLcUcICon.image = UIImage(named: containsLetter ? "tick" : "cross")
        
        let isPasswordValid = min8Characters && containsNumber && containsLetter
        signupBtn.isEnabled = isPasswordValid
    }
}

extension SignupVC {
    func setupTermsLabel() {
        let fullText = "I agree to the company Term of Service and Privacy Policy"
        let termsText = "Term of Service"
        let privacyText = "Privacy Policy"
        
        let attributedString = NSMutableAttributedString(string: fullText)
        let fullRange = NSRange(location: 0, length: fullText.count)
        let termsRange = (fullText as NSString).range(of: termsText)
        let privacyRange = (fullText as NSString).range(of: privacyText)
        
        // Set default color for the whole text
        attributedString.addAttribute(.foregroundColor, value: UIColor.textGreyColor, range: fullRange)
        
        // Set color for "Term of Service" and "Privacy Policy"
        attributedString.addAttribute(.foregroundColor, value: UIColor.appColor, range: termsRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.appColor, range: privacyRange)
        
        // Set attributed text to the label
        termsLabel.attributedText = attributedString
        termsLabel.isUserInteractionEnabled = true
        
        // Add gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(_:)))
        termsLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTapOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = termsLabel.attributedText?.string else { return }
        
        let termsText = "Term of Service"
        let privacyText = "Privacy Policy"
        
        let termsRange = (text as NSString).range(of: termsText)
        let privacyRange = (text as NSString).range(of: privacyText)
        
        if gesture.didTapAttributedTextInLabel(label: termsLabel, inRange: termsRange) {
            print("Term of Service tapped")
            openWebView(urlString: "www.monso.tech/termsofservice_EN.pdf", isTerms: true)
        } else if gesture.didTapAttributedTextInLabel(label: termsLabel, inRange: privacyRange) {
            print("Privacy Policy tapped")
            openWebView(urlString: "www.monso.tech/privacypolicy_EN.pdf", isTerms: false)
        } else {
            print("unidentified")
        }
    }
    
    func openWebView(urlString: String, isTerms: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: WebViewController.self)) as? WebViewController {
            secondViewController.urlString = urlString
            secondViewController.isTerms = isTerms
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
}

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attributedText = label.attributedText else { return false }
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(size: CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        layoutManager.addTextContainer(textContainer)
        
        layoutManager.glyphRange(for: textContainer) // Ensures proper layout
        
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(
            x: (label.bounds.size.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
            y: (label.bounds.size.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        )
        
        let locationOfTouchInTextContainer = CGPoint(
            x: locationOfTouchInLabel.x - textContainerOffset.x,
            y: locationOfTouchInLabel.y - textContainerOffset.y
        )
        
        let characterIndex = layoutManager.characterIndex(
            for: locationOfTouchInTextContainer,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        
        print("locationOfTouchInLabel: \(locationOfTouchInLabel)")
        print("textBoundingBox: \(textBoundingBox)")
        print("textContainerOffset: \(textContainerOffset)")
        print("locationOfTouchInTextContainer: \(locationOfTouchInTextContainer)")
        print("characterIndex: \(characterIndex)")
        
        return NSLocationInRange(characterIndex, targetRange)
    }
}
