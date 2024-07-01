//
//  DeviceProfileListCell.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 15/06/2024.
//

import UIKit

class DeviceProfileListCell: UITableViewCell {
    
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var endView: UIView!
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(data: Trigger) {
        lblStartDate.text = data.startdate ?? ""
        lblStartTime.text = data.starttime ?? ""
        lblEndDate.text = data.enddate ?? ""
        lblEndTime.text = data.endtime ?? ""
        if data.resolved ?? true {
            endView.isHidden = false
            startView.backgroundColor = UIColor.hexStringToUIColor(hex: "F2D9D9")
            endView.backgroundColor = UIColor.hexStringToUIColor(hex: "D9F2D9")
        } else {
            endView.isHidden = true
            startView.backgroundColor = UIColor.hexStringToUIColor(hex: "D9F2D9")
        }
    }
    
}
