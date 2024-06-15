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
}

class HomeListCell: UITableViewCell {
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var viewButton: UIView!
    
    weak var delegate: HomeListCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func profilePressed(_ sender: Any) {
        self.delegate?.openProfilePage()
    }
    @IBAction func viewButtonPressed(_ sender: Any) {
        self.delegate?.openViewPage()
    }
}
