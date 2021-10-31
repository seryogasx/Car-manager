//
//  VehicleInfoTableViewCell.swift
//  CarManager
//
//  Created by Сергей Петров on 25.10.2021.
//

import UIKit

class CarInfoTableViewCell: UITableViewCell, ReuseIdentifying {
    
    @IBOutlet weak var ModelLabel: UILabel!
    @IBOutlet weak var MarkLabel: UILabel!
    @IBOutlet weak var YearLabel: UILabel!
    @IBOutlet weak var MileageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
    }
    
    func setup(mark: String?, model: String?, year: Int16?, mileage: Int?) {
        self.MarkLabel.text = mark ?? "-"
        self.ModelLabel.text = model ?? "-"
        if let year = year {
            self.YearLabel.text = "\(year)"
        } else {
            self.YearLabel.text = "-"
        }
        if let mileage = mileage {
            self.MileageLabel.text = "\(mileage)"
        } else {
            self.MileageLabel.text = "-"
        }
    }
}
