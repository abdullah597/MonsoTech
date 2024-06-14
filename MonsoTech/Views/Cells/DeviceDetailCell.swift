//
//  DeviceDetailCell.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 14/06/2024.
//

import UIKit

protocol DeviceDetailCellDelegate: AnyObject {
    func generatecCode()
}

class DeviceDetailCell: UITableViewCell {
    weak var delegate: DeviceDetailCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func generateCode(_ sender: Any) {
        self.delegate?.generatecCode()
    }
    
}
