//
//  WatchersTableViewCell.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 29/06/2024.
//

import UIKit

protocol WatchersTableViewCellDelegate: AnyObject {
    func deletewatcher(index: Int)
}

class WatchersTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: WatchersTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func setCell(data: Watcher) {
        lblName.text = data.name ?? "N/A"
    }
    @IBAction func deleteWatcher(_ sender: Any) {
        self.delegate?.deletewatcher(index: deleteButton.tag)
    }
    
}
