//
//  DeviceDetailVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 14/06/2024.
//

import UIKit

class DeviceDetailVC: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var deviceDetail: Device?
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.shared.setTopCorners(view: mainView, radius: 30)
        registerNibs()
        loader.isHidden = true
    }
    func registerNibs() {
        self.tableView.register(UINib(nibName: String(describing: DeviceDetailCell.self), bundle: nil), forCellReuseIdentifier: String(describing: DeviceDetailCell.self))
        self.tableView.register(UINib(nibName: String(describing: WatchersTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: WatchersTableViewCell.self))
        self.tableView.register(UINib(nibName: String(describing: BottomButtonsTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: BottomButtonsTableViewCell.self))
        self.tableView.reloadData()
    }
    @IBAction func back(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
}
extension DeviceDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.deviceDetail?.watchers?.count ?? 0
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DeviceDetailCell.self)) as? DeviceDetailCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.delegate = self
            guard let data = self.deviceDetail else { return UITableViewCell() }
            cell.setCell(data: data)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WatchersTableViewCell.self)) as? WatchersTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.delegate = self
            guard let data = self.deviceDetail?.watchers?[indexPath.row] else { return UITableViewCell() }
            cell.setCell(data: data)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BottomButtonsTableViewCell.self)) as? BottomButtonsTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DeviceDetailVC: DeviceDetailCellDelegate {
    func savesetting(alarm: Bool, notification: Bool) {
        Utilities.shared.showLoader(loader: loader)
        let body = RequestBodySaveSettings(
            charcode: self.deviceDetail?.charcode ?? "",
            name: self.deviceDetail?.name ?? "",
            devicetype: self.deviceDetail?.devicetype ?? "",
            alarm_when_removed: alarm,
            send_push_notifaction: notification
        )
        APIManager.shared.patchData(endpoint: .devices, requestBody: body, viewController: self) { (statusCode, result: APIResult<String>) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    Utilities.shared.hideLoader(loader: self.loader)
                    AlertManager.shared.showAlert(on: self, message: "Device detail updated successfully", actionText: "OK") {}
                }
            case .failure(_):
                    AlertManager.shared.showAlert(on: self, message: "Failed to update device detail", actionText: "OK") {}
            }
        }
    }

}

extension DeviceDetailVC: WatchersTableViewCellDelegate {
    func deletewatcher(index: Int) {
        Utilities.shared.showLoader(loader: loader)
        let body = RequestBodyDeleteWatcher(oid: Constants.oid, charcode: self.deviceDetail?.charcode ?? "", removewatcher: self.deviceDetail?.watchers?[index].oid ?? "")
        APIManager.shared.patchData(endpoint: .registration, requestBody: body, viewController: self) { (code, result: APIResult<String>) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    Utilities.shared.hideLoader(loader: self.loader)
                    AlertManager.shared.showAlert(on: self, message: "Watcher Deleted successfully", actionText: "OK") {}
                }
            case .failure(_):
                    AlertManager.shared.showAlert(on: self, message: "Failed to Delete Watcher", actionText: "OK") {}
            }
        }
    }
}
struct RequestBodyDeleteWatcher: Codable {
    let oid, charcode, removewatcher: String?
}

extension DeviceDetailVC: BottomButtonsTableViewCellDelegate {
    func generateCode() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: GenerateCodeVC.self)) as? GenerateCodeVC {
            secondViewController.charCode = self.deviceDetail?.charcode ?? ""
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
    
    func report() {
        Utilities.shared.showLoader(loader: loader)
        let body = ReportBody(oid: Constants.oid, charcode: self.deviceDetail?.charcode ?? "", message: "fault button pressed on device detail page")
        APIManager.shared.postData(endpoint: .fault, requestBody: body, viewController: self) { (code, result: APIResult<String>) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    Utilities.shared.hideLoader(loader: self.loader)
                    AlertManager.shared.showAlert(on: self, message: "Reported", actionText: "OK") {}
                }
            case .failure(_):
                DispatchQueue.main.async {
                    AlertManager.shared.showAlert(on: self, message: "Failed", actionText: "OK") {}
                }
            }
        }
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

struct ReportBody: Codable {
    let oid, charcode, message: String?
}

struct DisconnectRequestBody: Codable {
    let oid, charcode: String?
    let disconnect: Bool?
}
