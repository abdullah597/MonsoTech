//
//  DeviceProfileVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 15/06/2024.
//

import UIKit

class DeviceProfileVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var deviceDetail: Device?
    var profileDetail: ProfileDevice?
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.isHidden = true
        getDetails()
        registerNibs()
        Utilities.shared.setTopCorners(view: mainView, radius: 30)
        resetAllTriggers()
        lblTitle.text = self.deviceDetail?.name ?? "N/A"
    }
    
    func resetAllTriggers() {
        APIManager.shared.postData(endpoint: .triggers(charcode: self.deviceDetail?.charcode ?? ""), requestBody: ResetTriggersBody(key: "reset_all_triggers"), viewController: self) { (code, result: APIResult<String>) in
            switch result {
            case .success(let t):
                print(t)
            case .failure(let aPIError):
                print(aPIError)
            }
        }
    }
    func getDetails() {
        Utilities.shared.showLoader(loader: loader)
        APIManager.shared.fetchData(endpoint: .triggers(charcode: self.deviceDetail?.charcode ?? ""), viewController: self) { (code, result: APIResult<ProfileDevice>) in
            switch result {
            case .success(let t):
                print(t)
                DispatchQueue.main.async {
                    Utilities.shared.hideLoader(loader: self.loader)
                    self.profileDetail = t
                    self.tableView.reloadData()
                }
                
            case .failure(let aPIError):
                Utilities.shared.hideLoader(loader: self.loader)
                print(aPIError)
            }
        }
    }
    func registerNibs() {
        self.tableView.register(UINib(nibName: String(describing: DeviceProfileListCell.self), bundle: nil), forCellReuseIdentifier: String(describing: DeviceProfileListCell.self))
    }
    @IBAction func back(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
}

extension DeviceProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.profileDetail?.triggers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DeviceProfileListCell.self)) as? DeviceProfileListCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        guard let data = self.profileDetail?.triggers?[indexPath.row] else { return UITableViewCell() }
        cell.setCell(data: data)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

struct ResetTriggersBody: Codable {
    let key: String?
}
