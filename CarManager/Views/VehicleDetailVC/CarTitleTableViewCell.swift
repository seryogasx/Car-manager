//
//  VehicleTitleTableViewCell.swift
//  CarManager
//
//  Created by Сергей Петров on 25.10.2021.
//

import UIKit

class CarTitleTableViewCell: UITableViewCell, ReuseIdentifying {

    @IBOutlet weak var CarImageView: UIImageView!
    @IBOutlet weak var CarNameLabel: UILabel!
//    @IBOutlet weak var VehicleImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var CarImageHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CarImageHeightConstraint.constant = UIScreen.main.bounds.height / 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
    }
    
    func setup(name: String) {
        CarNameLabel.text = name
        CarImageView.contentMode = .scaleAspectFill
        CarImageView.layer.cornerRadius = 20
        CarImageView.image = UIImage(named: "octaha")
    }
}
