//
//  CustomTableViewCell.swift
//  BambooTreeForest
//
//  Created by 정한얼 on 12/19/24.
//

import UIKit

protocol CustomTableViewCellDelegate: AnyObject {
    func didTapButton(in cell: CustomTableViewCell)
}

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    weak var delegate: CustomTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        delegate?.didTapButton(in: self)
    }
}

