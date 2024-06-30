//
//  BottomButtonsTableViewCell.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 29/06/2024.
//

import UIKit

protocol BottomButtonsTableViewCellDelegate: AnyObject {
    func generateCode()
    func report()
    func disconnect()
}

class BottomButtonsTableViewCell: UITableViewCell {

    weak var delegate: BottomButtonsTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func cod(_ sender: Any) {
        self.delegate?.generateCode()
    }
    @IBAction func fault(_ sender: Any) {
        self.delegate?.report()
    }
    
    @IBAction func disconnect(_ sender: Any) {
        self.delegate?.disconnect()
    }
}
