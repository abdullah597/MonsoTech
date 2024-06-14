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
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.shared.setTopCorners(view: mainView, radius: 30)
        registerNibs()
    }
    func registerNibs() {
        self.tableView.register(UINib(nibName: String(describing: DeviceDetailCell.self), bundle: nil), forCellReuseIdentifier: String(describing: DeviceDetailCell.self))
    }
    @IBAction func back(_ sender: Any) {
        Utilities.shared.popViewController(currentViewController: self, animated: true)
    }
}
extension DeviceDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DeviceDetailCell.self)) as? DeviceDetailCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DeviceDetailVC: DeviceDetailCellDelegate {
    func generatecCode() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: GenerateCodeVC.self)) as? GenerateCodeVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
}
