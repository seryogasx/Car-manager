//
//  VehicleTableViewCell.swift
//  CarManager
//
//  Created by Сергей Петров on 23.10.2021.
//

import UIKit

class VehicleTableViewCell: UITableViewCell {

    @IBOutlet weak var VehicleImageView: UIImageView!
    @IBOutlet weak var VehicleNameLabel: UILabel!
    @IBOutlet weak var VehicleImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var VehicleImageViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        VehicleImageViewWidthConstraint.constant = UIScreen.main.bounds.width / 3
        VehicleImageViewHeightConstraint.constant = UIScreen.main.bounds.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(vehicleName: String) {
        self.VehicleNameLabel.text = vehicleName
        let image = UIImage(named: "octaha")!
        self.VehicleImageView.contentMode = .scaleAspectFill
        self.VehicleImageView.image = image
    }
    
}
