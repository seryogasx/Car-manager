//
//  VehicleTitleTableViewCell.swift
//  CarManager
//
//  Created by Сергей Петров on 25.10.2021.
//

import UIKit

class VehicleTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var VehicleImageView: UIImageView!
    @IBOutlet weak var VehicleNameLabel: UILabel!
//    @IBOutlet weak var VehicleImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var VehicleImageHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        VehicleImageHeightConstraint.constant = UIScreen.main.bounds.height / 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(name: String) {
        VehicleNameLabel.text = name
        VehicleImageView.contentMode = .scaleAspectFill
        VehicleImageView.layer.cornerRadius = 20
        VehicleImageView.image = UIImage(named: "octaha")
    }
}
