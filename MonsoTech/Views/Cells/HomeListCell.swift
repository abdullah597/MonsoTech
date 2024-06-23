//
//  HomeListCell.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 14/06/2024.
//

import UIKit

protocol HomeListCellDelegate: AnyObject {
    func openProfilePage()
    func openViewPage()
    func openSettings()
    func openDetailPage()
}

class HomeListCell: UITableViewCell {
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var lblDetail: UILabel!
    weak var delegate: HomeListCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func lighteningPressed(_ sender: Any) {
        self.delegate?.openProfilePage()
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
            self.delegate?.openDetailPage()
        } else {
            self.delegate?.openViewPage()
        }
    }
}
