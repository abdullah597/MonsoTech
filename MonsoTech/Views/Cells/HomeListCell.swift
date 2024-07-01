//
//  HomeListCell.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 14/06/2024.
//

import UIKit

protocol HomeListCellDelegate: AnyObject {
    func openProfilePage(index: Int)
    func openViewPage(index: Int)
    func openSettings()
    func openDetailPage(index: Int)
}

class HomeListCell: UITableViewCell {
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    
    weak var delegate: HomeListCellDelegate?
    var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func setCell(data: Device) {
        lblTitle.text = data.name ?? "N/a"
        if data.role == "owner" {
            profileButton.isHidden = false
            viewButton.isHidden = true
        } else {
            profileButton.isHidden = true
            viewButton.isHidden = false
        }
        if (data.trigercountunread ?? 0) == 0 {
           bottomView.backgroundColor = UIColor.hexStringToUIColor(hex: "D9F2D9")
            lblDetail.text = "\(data.trigercount ?? 02) events in the past"
        } else {
           bottomView.backgroundColor = UIColor.hexStringToUIColor(hex: "F2D9D9")
           lblDetail.text = "new power outage"
        }
    }
    
    @IBAction func lighteningPressed(_ sender: Any) {
        self.delegate?.openProfilePage(index: self.index)
    }
    @IBAction func openDetail(_ sender: Any) {
       // self.delegate?.openDetailPage()
    }
    @IBAction func profilePressed(_ sender: Any) {
        //self.delegate?.openProfilePage()
    }
    @IBAction func viewButtonPressed(_ sender: Any) {
        //self.delegate?.openViewPage()
    }
    @IBAction func openSettings(_ sender: Any) {
        if viewButton.isHidden == true {
            self.delegate?.openDetailPage(index: self.index)
        } else {
            self.delegate?.openViewPage(index: self.index)
        }
    }
}
