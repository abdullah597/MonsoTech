//
//  DeviceDetailCell.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 14/06/2024.
//

import UIKit

protocol DeviceDetailCellDelegate: AnyObject {
    func savesetting(alarm: Bool, notification: Bool, name: String)
}

class DeviceDetailCell: UITableViewCell {
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var generateAlarmSwitch: UISwitch!
    @IBOutlet weak var sendNotiSwitch: UISwitch!
    
    weak var delegate: DeviceDetailCellDelegate?
    var data: Device?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setCell(data: Device) {
        self.data = data
        lblProductName.text = data.devicetype ?? "N/A"
        nameTF.text = data.name
        if (data.settings?.count ?? 0) > 0 {
            if (data.settings?.count ?? 0) == 1 {
                generateAlarmSwitch.isOn = data.settings?[0].value ?? true
                sendNotiSwitch.isOn = false
            } else {
                generateAlarmSwitch.isOn = data.settings?[0].value ?? true
                sendNotiSwitch.isOn = data.settings?[1].value ?? true
            }
        }
    }
    
    @IBAction func saveSettings(_ sender: Any) {
        self.delegate?.savesetting(alarm: generateAlarmSwitch.isOn, notification: sendNotiSwitch.isOn, name: nameTF.text ?? "")
    }
}
struct RequestBodySaveSettings: Codable {
    let charcode, name, devicetype: String?
    let alarm_when_removed, send_push_notifaction: Bool?
}
