//
//  Step4ConnectVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 13/06/2024.
//

import UIKit
import AVFoundation

class Step4ConnectVC: UIViewController {
    
    @IBOutlet weak var qrView: UIView!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraPermission()
    }
    deinit {
        if (captureSession != nil && captureSession.isRunning) {
            captureSession.stopRunning()
        }
    }
    @IBAction func back(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
    @IBAction func previousStep(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
    @IBAction func next(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: Step5ConnectVC.self)) as? Step5ConnectVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
}

extension Step4ConnectVC: AVCaptureMetadataOutputObjectsDelegate {
    func setupScanner() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = qrView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        qrView.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func failed() {
        let alertController = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
        captureSession = nil
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        print("QR Code: \(code)")
//        if code == "AAAAA123" || code == "AAAAB678" {
//            
            self.connectDevice(code: code)
//        } else {
//            AlertManager.shared.showAlert(on: self, message: "Wrong", actionText: "Dismiss") {}
//        }
    }
    func connectDevice(code: String) {
        let letters = String(code.prefix(5))
            let digits = String(code.suffix(3))
            
            // Check if the first 5 characters are letters and the last 3 are digits
            let isLettersValid = letters.allSatisfy { $0.isLetter }
            let isDigitsValid = digits.allSatisfy { $0.isNumber }
            
            if isLettersValid && isDigitsValid {
                print("Letters: \(letters), Digits: \(digits)")
                // Handle the valid QR code
            } else {
                print("Invalid QR Code format")
            }
        // Constructing the request body
        let connectionRequest = RequestBodyDevice(
            oid: Constants.oid,
            role: "owner",
            charcode: letters,
            digitcode: Int(digits)
        )
        
        // Calling APIManager to post data
        APIManager.shared.postData(endpoint: .registration, requestBody: connectionRequest, viewController: self) { (code, result: APIResult<[String: String]>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success(_):
                    if code == 200 || code == 201 {
                        Utilities.shared.goToHome(controller: self)
                    } else if code == 400 {
                        AlertManager.shared.showAlert(on: self, message: "Device Already Paired", actionText: "Go to Devices") {
                            Utilities.shared.goToHome(controller: self)
                        }
                    }else {
                        AlertManager.shared.showAlert(on: self, message: "Wrong Connection Code", actionText: "Dismiss") {}
                    }
                    
                case .failure(let error):
                    AlertManager.shared.showAlert(on: self, message: "Wrong Connection Code", actionText: "Dismiss") {}
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession.isRunning) {
            captureSession.stopRunning()
        }
    }
    
    func checkCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            DispatchQueue.main.async {
                self.setupScanner()
            }
            
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setupScanner()
                    }
                }
            }
            
        case .denied, .restricted:
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Camera Access Needed", message: "Please enable camera access in Settings", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
            
        @unknown default:
            fatalError()
        }
    }
    
}
