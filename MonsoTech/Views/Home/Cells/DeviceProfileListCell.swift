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
    @IBOutlet weak var startclockIcon: UIImageView!
    @IBOutlet weak var startCalendarIcon: UIImageView!
    @IBOutlet weak var endClockIcomn: UIImageView!
    @IBOutlet weak var calendarEndIcon: UIImageView!
    
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
            startView.backgroundColor = UIColor.greenColor
            endView.backgroundColor = UIColor.greenColor
            startclockIcon.tintColor = UIColor.greenColor
            startCalendarIcon.tintColor = UIColor.greenColor
            endClockIcomn.tintColor = UIColor.greenColor
            calendarEndIcon.tintColor = UIColor.greenColor
        } else {
            endView.isHidden = true
            startView.backgroundColor = UIColor.redColor
            startclockIcon.tintColor = UIColor.redColor
            startCalendarIcon.tintColor = UIColor.redColor
            endClockIcomn.tintColor = UIColor.redColor
            calendarEndIcon.tintColor = UIColor.redColor
        }
    }
    
}
// D9F2D9 -> green
// F2D9D9 -> red
