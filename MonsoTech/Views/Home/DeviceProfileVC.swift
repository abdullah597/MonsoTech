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
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        Utilities.shared.setTopCorners(view: mainView, radius: 30)

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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DeviceProfileListCell.self)) as? DeviceProfileListCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
